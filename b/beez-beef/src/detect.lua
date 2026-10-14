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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_beef_proj(ctx)
    local files = ctx.glob({ "BeefProj.toml", "**/BeefProj.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(beef_proj_path)
    if beef_proj_path == nil then
        return "."
    end
    return dirname(beef_proj_path)
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "src/main.bf",
        prefix .. "main.bf",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.bf" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("_test%.bf$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.bf" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("_test%.bf$") and not source:match("/tests/") and not source:match("/test/") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.bf",
        prefix .. "test/**/*.bf",
        prefix .. "**/*_test.bf",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local beef_proj_path = cfg.beef_proj_path
    if beef_proj_path == nil then
        beef_proj_path = M.find_beef_proj(ctx)
    end

    local bf_files = ctx.glob({ "**/*.bf" })
    if beef_proj_path == nil and #bf_files == 0 then
        error("beef plugin: no BeefProj.toml or *.bf files found — add a Beef project or set beef_proj_path in configure()")
    end

    local root = cfg.project_root or M.project_root(beef_proj_path)
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/beef/bin"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        beef_proj_path = beef_proj_path,
        has_beef_proj = beef_proj_path ~= nil,
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
