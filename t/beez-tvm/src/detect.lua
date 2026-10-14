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
end

local function has_tvm_import(path)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return false
    end

    local content = file:read("*a")
    file:close()

    if content == nil then
        return false
    end

    return content:match("import%s+tvm") ~= nil
        or content:match("from%s+tvm%s+import") ~= nil
        or content:match("from%s+tvm%.") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.resolve_entry(ctx, root, cfg_entry, cfg_kind)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry, cfg_kind or "script"
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local compile_scripts = ctx.glob({
        prefix .. "/**/*compile*.py",
        prefix .. "/*compile*.py",
        prefix .. "/**/*tvm*.py",
        prefix .. "/*tvm*.py",
    })
    sort_shallow_first(compile_scripts)
    for _, script in ipairs(compile_scripts) do
        if not is_test_path(script) and has_tvm_import(script) then
            return script, "script"
        end
    end

    local relay_files = ctx.glob({
        prefix .. "/**/*.relay",
        prefix .. "/*.relay",
    })
    sort_shallow_first(relay_files)
    if #relay_files > 0 then
        return relay_files[1], "relay"
    end

    local tir_files = ctx.glob({
        prefix .. "/**/*.tir",
        prefix .. "/*.tir",
    })
    sort_shallow_first(tir_files)
    if #tir_files > 0 then
        return tir_files[1], "tir"
    end

    for _, script in ipairs(compile_scripts) do
        if not is_test_path(script) then
            return script, "script"
        end
    end

    return nil, nil
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
    local relay_files = ctx.glob({ "**/*.relay" })
    local tir_files = ctx.glob({ "**/*.tir" })
    local py_files = ctx.glob({ "**/*compile*.py", "**/*tvm*.py" })

    local requirements_path = cfg.requirements_path
    if requirements_path == nil then
        requirements_path = M.find_manifest(ctx, "requirements.txt")
    end

    local root = cfg.project_root
    if root == nil then
        if requirements_path ~= nil then
            root = dirname(requirements_path)
        else
            root = "."
        end
    end

    local entry_source, entry_kind = M.resolve_entry(ctx, root, cfg.entry_source, cfg.entry_kind)

    if entry_source == nil and #relay_files == 0 and #tir_files == 0 and #py_files == 0 then
        error("tvm plugin: no *.relay, *.tir, or TVM compile scripts found — add model sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/tvm"
    local output_name = cfg.output_name or "model.so"
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
        entry_kind = entry_kind or "script",
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
