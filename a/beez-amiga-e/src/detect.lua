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

local function basename_no_ext(path)
    local name = path:match("([^/]+)$") or path
    return name:gsub("%.e$", "")
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.e",
        prefix .. "src/main.e",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.e" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("_test%.e$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.e" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("_test%.e$")
            and not source:match("/tests/")
            and not source:match("/test/") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "**/*_test.e",
        prefix .. "test/**/*.e",
        prefix .. "tests/**/*.e",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local e_files = ctx.glob({ "**/*.e" })
    if #e_files == 0 then
        error("amiga-e plugin: no *.e files found — add an Amiga E project or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/amiga-e/bin"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        entry_basename = entry_source and basename_no_ext(entry_source) or nil,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
