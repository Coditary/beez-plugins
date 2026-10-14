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

function M.find_entry_roc(ctx)
    local candidates = ctx.glob({ "app.roc", "**/app.roc", "main.roc", "**/main.roc" })
    if #candidates == 0 then
        return nil
    end

    sort_shallow_first(candidates)
    return candidates[1]
end

function M.project_root(entry_path)
    if entry_path == nil then
        return "."
    end
    return dirname(entry_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.roc",
        prefix .. "test/**/*.roc",
        prefix .. "**/*_test.roc",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local entry_path = cfg.entry_path
    if entry_path == nil then
        entry_path = M.find_entry_roc(ctx)
    end

    local rocs = ctx.glob({ "**/*.roc" })
    if entry_path == nil and #rocs == 0 then
        error("roc plugin: no app.roc or *.roc files found — add a Roc project or set entry_path in configure()")
    end

    local root = cfg.project_root or M.project_root(entry_path)
    local bin_dir = cfg.bin_dir or "build/roc/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        entry_path = entry_path,
        has_entry = entry_path ~= nil,
        project_root = root,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
