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

function M.resolve_source_dir(entry_source)
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

    local root_cmake = ctx.glob({
        prefix .. "/CMakeLists.txt",
        prefix .. "/**/CMakeLists.txt",
    })

    sort_shallow_first(root_cmake)

    for _, file in ipairs(root_cmake) do
        if not is_test_file(file) then
            return file
        end
    end

    if #root_cmake > 0 then
        return root_cmake[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/CMakeLists.txt",
        prefix .. "/tests/**/CMakeLists.txt",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local cmake_files = ctx.glob({ "CMakeLists.txt", "**/CMakeLists.txt" })

    if entry_source == nil and #cmake_files == 0 then
        error("cmake plugin: no CMakeLists.txt files found — add CMake sources or set entry_source in configure()")
    end

    local cmake_build_dir = cfg.build_dir or "build/cmake"
    local bin_dir = cfg.bin_dir or cmake_build_dir .. "/bin"
    local output_name = cfg.output_name or "build.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local source_dir = M.resolve_source_dir(entry_source)
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        source_dir = source_dir,
        cmake_build_dir = cmake_build_dir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
