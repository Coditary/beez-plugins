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

function M.resolve_compdb(ctx, root, cfg_compdb)
    if cfg_compdb ~= nil and cfg_compdb ~= "" then
        return cfg_compdb
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/compile_commands.json",
        prefix .. "/**/compile_commands.json",
        "compile_commands.json",
        "**/compile_commands.json",
    })

    sort_shallow_first(files)

    for _, file in ipairs(files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #files > 0 then
        return files[1]
    end

    return nil
end

function M.resolve_object_files(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*.o",
        prefix .. "/*.o",
        "**/*.o",
    })

    sort_shallow_first(files)

    local objects = {}
    for _, file in ipairs(files) do
        if not is_test_file(file) then
            objects[#objects + 1] = file
        end
    end

    return objects
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.o",
        prefix .. "/tests/**/*.o",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local compdb = M.resolve_compdb(ctx, root, cfg.compdb)
    local object_files = cfg.object_files or M.resolve_object_files(ctx, root)
    local compdb_files = ctx.glob({ "compile_commands.json", "**/compile_commands.json" })

    if compdb == nil and #object_files == 0 and #compdb_files == 0 then
        error("lld plugin: no compile_commands.json or object files found — run a compile step first or set compdb/object_files in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/lld/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        compdb = compdb,
        object_files = object_files,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
