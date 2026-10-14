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

local function is_test_file(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("test_") ~= nil
        or path:match("_test%.") ~= nil
end

function M.is_markdown(path)
    return path:match("%.md$") ~= nil or path:match("%.markdown$") ~= nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local ditaa_files = ctx.glob({
        prefix .. "/**/*.ditaa",
        prefix .. "/*.ditaa",
    })

    sort_shallow_first(ditaa_files)

    for _, file in ipairs(ditaa_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #ditaa_files > 0 then
        return ditaa_files[1]
    end

    local markdown_files = ctx.glob({
        prefix .. "/**/*.md",
        prefix .. "/*.md",
    })

    sort_shallow_first(markdown_files)

    for _, file in ipairs(markdown_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #markdown_files > 0 then
        return markdown_files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.ditaa",
        prefix .. "/tests/**/*.ditaa",
        prefix .. "/test/**/*.md",
        prefix .. "/tests/**/*.md",
        prefix .. "/**/test_*.ditaa",
        prefix .. "/**/*_test.ditaa",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local source_files = ctx.glob({ "**/*.ditaa", "**/*.md" })

    if entry_source == nil and #source_files == 0 then
        error("ditaa plugin: no *.ditaa or markdown files found — add ditaa sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/ditaa/bin"
    local output_name = cfg.output_name or "app.png"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        entry_is_markdown = entry_source ~= nil and M.is_markdown(entry_source),
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
