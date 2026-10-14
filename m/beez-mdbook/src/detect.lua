local M = {}

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

local function dirname(path)
    local dir = path:match("^(.*)/[^/]+$")
    if dir == nil or dir == "" then
        return "."
    end
    return dir
end

function M.resolve_book_toml(ctx, root, cfg_book_toml)
    if cfg_book_toml ~= nil and cfg_book_toml ~= "" then
        return cfg_book_toml, dirname(cfg_book_toml)
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local book_files = ctx.glob({
        prefix .. "/book.toml",
        prefix .. "/**/book.toml",
    })

    sort_shallow_first(book_files)

    if #book_files > 0 then
        local book_toml = book_files[1]
        return book_toml, dirname(book_toml)
    end

    return nil, nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/src/**/*.md",
        prefix .. "/**/tests/**/*.md",
        prefix .. "/**/test/**/*.md",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local book_tomls = ctx.glob({ "book.toml", "**/book.toml" })
    local md_files = ctx.glob({ "**/*.md" })

    if #book_tomls == 0 and #md_files == 0 then
        error("mdbook plugin: no book.toml or *.md files found — add an mdbook project or set book_toml in configure()")
    end

    local root = cfg.project_root or "."
    local book_toml, book_dir = M.resolve_book_toml(ctx, root, cfg.book_toml)

    if book_dir == nil then
        book_dir = root
    end

    local bin_dir = cfg.bin_dir or "build/mdbook/html"
    local output_name = cfg.output_name or "index.html"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        book_toml = book_toml,
        book_dir = book_dir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
