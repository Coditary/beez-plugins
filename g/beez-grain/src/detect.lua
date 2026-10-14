local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

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

function M.find_grain_json(ctx)
    local files = ctx.glob({ "grain.json", "**/grain.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(grain_json_path)
    if grain_json_path == nil then
        return "."
    end
    return dirname(grain_json_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.gr",
        prefix .. "src/main.gr",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.gr" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("%.test%.gr$") and not source:match("_test%.gr$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.gr" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("%.test%.gr$")
            and not source:match("_test%.gr$")
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
        prefix .. "**/*.test.gr",
        prefix .. "**/*_test.gr",
        prefix .. "test/**/*.gr",
        prefix .. "tests/**/*.gr",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local grain_json_path = cfg.grain_json_path
    if grain_json_path == nil then
        grain_json_path = M.find_grain_json(ctx)
    end

    local gr_files = ctx.glob({ "**/*.gr" })
    if grain_json_path == nil and #gr_files == 0 then
        error("grain plugin: no grain.json or *.gr files found — add a Grain project or set grain_json_path in configure()")
    end

    local root = cfg.project_root or M.project_root(grain_json_path)
    local output_name = cfg.output_name or "app.wasm"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/grain/bin"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        grain_json_path = grain_json_path,
        has_grain_json = grain_json_path ~= nil,
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
