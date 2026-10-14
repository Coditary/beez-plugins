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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_defaults_file(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "pandoc.yaml",
        "pandoc.yaml",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    return nil
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.md",
        prefix .. "index.md",
        prefix .. "README.md",
        prefix .. "main.rst",
        prefix .. "index.rst",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local md_files = ctx.glob({ prefix .. "*.md" })
    sort_shallow_first(md_files)
    if #md_files > 0 then
        return md_files[1]
    end

    local rst_files = ctx.glob({ prefix .. "*.rst" })
    sort_shallow_first(rst_files)
    if #rst_files > 0 then
        return rst_files[1]
    end

    local all_md = ctx.glob({ prefix .. "**/*.md" })
    sort_shallow_first(all_md)
    if #all_md > 0 then
        return all_md[1]
    end

    local all_rst = ctx.glob({ prefix .. "**/*.rst" })
    sort_shallow_first(all_rst)
    if #all_rst > 0 then
        return all_rst[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.md",
        prefix .. "test/**/*.md",
        prefix .. "tests/**/*.rst",
        prefix .. "test/**/*.rst",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local md_files = ctx.glob({ "**/*.md" })
    local rst_files = ctx.glob({ "**/*.rst" })
    local defaults_files = ctx.glob({ "pandoc.yaml", "**/pandoc.yaml" })

    if #md_files == 0 and #rst_files == 0 and #defaults_files == 0 then
        error("pandoc plugin: no *.md, *.rst, or pandoc.yaml found — add a document or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app.html"
    local defaults_file = cfg.defaults_file
    if defaults_file == nil then
        defaults_file = M.resolve_defaults_file(ctx, root)
    end

    local entry_source = cfg.entry_source
    if entry_source == nil and defaults_file == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local out_dir = cfg.out_dir or "build/pandoc/out"
    local primary_output = out_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        defaults_file = defaults_file,
        out_dir = out_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
