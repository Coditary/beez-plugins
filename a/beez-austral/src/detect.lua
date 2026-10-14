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

function M.find_module_au(ctx)
    local candidates = ctx.glob({ "Module.au", "**/Module.au", "main.au", "**/main.au" })
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
        prefix .. "test/**/*.au",
        prefix .. "tests/**/*.au",
        prefix .. "**/*_test.au",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local entry_path = cfg.entry_path
    if entry_path == nil then
        entry_path = M.find_module_au(ctx)
    end

    local aus = ctx.glob({ "**/*.au" })
    if entry_path == nil and #aus == 0 then
        error("austral plugin: no Module.au or *.au files found — add an Austral project or set entry_path in configure()")
    end

    local root = cfg.project_root or M.project_root(entry_path)
    local bin_dir = cfg.bin_dir or "build/austral/bin"
    local gen_dir = cfg.gen_dir or "build/austral/gen"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local gen_c_output = gen_dir .. "/" .. output_name .. ".c"
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        entry_path = entry_path,
        has_entry = entry_path ~= nil,
        project_root = root,
        bin_dir = bin_dir,
        gen_dir = gen_dir,
        output_name = output_name,
        primary_output = primary_output,
        gen_c_output = gen_c_output,
        has_tests = has_tests,
    }
end

return M
