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

function M.resolve_build_dir(entry_source)
    if entry_source == nil then
        return "."
    end

    local dir = entry_source:match("^(.*)/[^/]+$")
    if dir == nil or dir == "" then
        return "."
    end

    return dir
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local root_ninja = ctx.glob({
        prefix .. "/build.ninja",
        prefix .. "/**/build.ninja",
    })

    sort_shallow_first(root_ninja)

    for _, file in ipairs(root_ninja) do
        if not is_test_file(file) then
            return file
        end
    end

    if #root_ninja > 0 then
        return root_ninja[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/build.ninja",
        prefix .. "/tests/**/build.ninja",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local ninja_files = ctx.glob({ "build.ninja", "**/build.ninja" })

    if entry_source == nil and #ninja_files == 0 then
        error("ninja plugin: no build.ninja files found — add a Ninja manifest or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/ninja/bin"
    local output_name = cfg.output_name or "build.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local build_workdir = M.resolve_build_dir(entry_source)
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        build_workdir = build_workdir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
