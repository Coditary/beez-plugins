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

local function has_cadquery_import(path)
    local file = io.open(path, "r")
    if file == nil then
        return false
    end

    local content = file:read("*a")
    file:close()

    return content:match("import cadquery") ~= nil
        or content:match("from cadquery") ~= nil
end

function M.is_cadquery_source(path)
    if path:match("/cadquery/") ~= nil then
        return true
    end

    return has_cadquery_import(path)
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local cadquery_dir_files = ctx.glob({
        prefix .. "/cadquery/**/*.py",
        prefix .. "/**/cadquery/**/*.py",
    })

    sort_shallow_first(cadquery_dir_files)

    for _, file in ipairs(cadquery_dir_files) do
        if not is_test_file(file) then
            return file
        end
    end

    local py_files = ctx.glob({
        prefix .. "/**/*.py",
        prefix .. "/*.py",
    })

    sort_shallow_first(py_files)

    for _, file in ipairs(py_files) do
        if not is_test_file(file) and has_cadquery_import(file) then
            return file
        end
    end

    if #cadquery_dir_files > 0 then
        return cadquery_dir_files[1]
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
        prefix .. "/cadquery/**/test_*.py",
        prefix .. "/cadquery/**/*_test.py",
    })

    for _, file in ipairs(test_files) do
        if M.is_cadquery_source(file) then
            return true
        end
    end

    return false
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local cadquery_files = ctx.glob({ "**/cadquery/**/*.py", "**/*.py" })

    local has_cadquery = false
    for _, file in ipairs(cadquery_files) do
        if M.is_cadquery_source(file) then
            has_cadquery = true
            break
        end
    end

    if entry_source == nil and not has_cadquery then
        error("cadquery plugin: no CadQuery Python scripts found — add *.py with cadquery imports, cadquery/**/*.py, or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/cadquery"
    local output_name = cfg.output_name or "app.stl"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
