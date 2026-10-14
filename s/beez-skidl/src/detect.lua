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

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("/test_[^/]+%.py$") ~= nil
        or path:match("^test_[^/]+%.py$") ~= nil
end

local function has_skidl_import(path)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return false
    end

    local content = file:read("*a")
    file:close()

    if content == nil then
        return false
    end

    return content:match("import%s+skidl") ~= nil
        or content:match("from%s+skidl%s+import") ~= nil
        or content:match("from%s+skidl%.") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local skidl_files = ctx.glob({
        prefix .. "/**/*_skidl.py",
        prefix .. "/*_skidl.py",
    })
    sort_shallow_first(skidl_files)

    for _, file in ipairs(skidl_files) do
        if not is_test_path(file) then
            return file
        end
    end

    if #skidl_files > 0 then
        return skidl_files[1]
    end

    local py_files = ctx.glob({
        prefix .. "/**/*.py",
        prefix .. "/*.py",
    })
    sort_shallow_first(py_files)

    for _, file in ipairs(py_files) do
        if not is_test_path(file) and has_skidl_import(file) then
            return file
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.py",
        prefix .. "/tests/**/*.py",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local requirements_path = cfg.requirements_path
    if requirements_path == nil then
        requirements_path = M.find_manifest(ctx, "requirements.txt")
    end

    local skidl_files = ctx.glob({ "**/*_skidl.py" })
    local py_files = ctx.glob({ "**/*.py" })

    local root = cfg.project_root
    if root == nil then
        if requirements_path ~= nil then
            root = dirname(requirements_path)
        else
            root = "."
        end
    end

    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)

    if entry_source == nil and #skidl_files == 0 and #py_files == 0 then
        error("skidl plugin: no *_skidl.py or SKiDL Python sources found — add circuit scripts or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/skidl"
    local output_name = cfg.output_name or "netlist.net"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        requirements_path = requirements_path,
        has_requirements = requirements_path ~= nil,
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
