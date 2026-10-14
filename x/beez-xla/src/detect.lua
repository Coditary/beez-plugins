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

local function has_xla_content(path)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return false
    end

    local content = file:read("*a")
    file:close()

    if content == nil then
        return false
    end

    return content:match("xla") ~= nil
        or content:match("tf2xla") ~= nil
        or content:match("XLA") ~= nil
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
        return cfg_entry, cfg_kind or "mlir"
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local mlir_files = ctx.glob({
        prefix .. "/**/*.mlir",
        prefix .. "/*.mlir",
    })
    sort_shallow_first(mlir_files)
    if #mlir_files > 0 then
        return mlir_files[1], "mlir"
    end

    local saved_models = ctx.glob({
        prefix .. "/**/saved_model.pb",
        prefix .. "/**/saved_model/**",
    })
    sort_shallow_first(saved_models)
    if #saved_models > 0 then
        local entry = saved_models[1]
        if entry:match("saved_model%.pb$") then
            return dirname(entry), "saved_model"
        end
        return entry, "saved_model"
    end

    local xla_scripts = ctx.glob({
        prefix .. "/**/*xla*.py",
        prefix .. "/*xla*.py",
        prefix .. "/**/compile*.py",
    })
    sort_shallow_first(xla_scripts)
    for _, script in ipairs(xla_scripts) do
        if has_xla_content(script) then
            return script, "script"
        end
    end

    local xla_config = M.find_manifest(ctx, "xla_config.json")
    if xla_config ~= nil then
        return xla_config, "config"
    end

    local xla_json = ctx.glob({ prefix .. "/**/xla/*.json" })
    sort_shallow_first(xla_json)
    if #xla_json > 0 then
        return xla_json[1], "config"
    end

    return nil, nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.mlir",
        prefix .. "/tests/**/*.mlir",
        prefix .. "/test/**/*xla*.py",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local mlir_files = ctx.glob({ "**/*.mlir" })
    local saved_models = ctx.glob({ "**/saved_model.pb", "**/saved_model/**" })
    local xla_configs = ctx.glob({ "xla_config.json", "**/xla_config.json", "**/xla/*.json" })

    local root = cfg.project_root or "."
    local entry_source, entry_kind = M.resolve_entry(ctx, root, cfg.entry_source, cfg.entry_kind)

    if entry_source == nil and #mlir_files == 0 and #saved_models == 0 and #xla_configs == 0 then
        error("xla plugin: no *.mlir, saved_model, or xla config found — add ML inputs or set entry_source in configure()")
    end

    if entry_source ~= nil and root == "." then
        root = dirname(entry_source)
    end

    local bin_dir = cfg.bin_dir or "build/xla"
    local output_name = cfg.output_name or "output.mlir"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        entry_kind = entry_kind or "mlir",
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
