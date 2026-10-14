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

local function has_implicitcad_import(path)
    local file = io.open(path, "r")
    if file == nil then
        return false
    end

    local content = file:read("*a")
    file:close()

    return content:match("Graphics%.Implicit") ~= nil
        or content:match("ImplicitCAD") ~= nil
end

function M.is_implicitcad_source(path)
    if path:match("%.hs$") ~= nil then
        return has_implicitcad_import(path)
    end

    if path:match("%.scad$") ~= nil then
        return true
    end

    return false
end

function M.source_kind(path)
    if path == nil then
        return nil
    end

    if path:match("%.hs$") ~= nil then
        return "hs"
    end

    if path:match("%.scad$") ~= nil then
        return "scad"
    end

    return nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local hs_files = ctx.glob({
        prefix .. "/**/*.hs",
        prefix .. "/*.hs",
    })

    sort_shallow_first(hs_files)

    for _, file in ipairs(hs_files) do
        if not is_test_file(file) and has_implicitcad_import(file) then
            return file
        end
    end

    local scad_files = ctx.glob({
        prefix .. "/**/*.scad",
        prefix .. "/*.scad",
    })

    sort_shallow_first(scad_files)

    for _, file in ipairs(scad_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #hs_files > 0 then
        return hs_files[1]
    end

    if #scad_files > 0 then
        return scad_files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.scad",
        prefix .. "/tests/**/*.scad",
        prefix .. "/test/**/*.hs",
        prefix .. "/tests/**/*.hs",
        prefix .. "/**/test_*.scad",
        prefix .. "/**/*_test.scad",
        prefix .. "/**/test_*.hs",
        prefix .. "/**/*_test.hs",
    })

    for _, file in ipairs(test_files) do
        if M.is_implicitcad_source(file) then
            return true
        end
    end

    return false
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local source_files = ctx.glob({ "**/*.scad", "**/*.hs" })

    local has_implicitcad = false
    for _, file in ipairs(source_files) do
        if M.is_implicitcad_source(file) then
            has_implicitcad = true
            break
        end
    end

    if entry_source == nil and not has_implicitcad then
        error("implicitcad plugin: no ImplicitCAD sources found — add *.scad, *.hs with Graphics.Implicit, or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/implicitcad"
    local output_name = cfg.output_name or "app.stl"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        source_kind = M.source_kind(entry_source),
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
