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

function M.has_config_in(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local config_in = ctx.glob({
        prefix .. "/Config.in",
        prefix .. "/**/Config.in",
    })

    return #config_in > 0
end

function M.resolve_defconfig(ctx, root, cfg_defconfig)
    if cfg_defconfig ~= nil and cfg_defconfig ~= "" then
        return cfg_defconfig
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local defconfigs = ctx.glob({
        prefix .. "/**/*defconfig",
        prefix .. "/*defconfig",
        prefix .. "/configs/*defconfig",
    })

    sort_shallow_first(defconfigs)

    for _, file in ipairs(defconfigs) do
        if not is_test_file(file) then
            return file
        end
    end

    if #defconfigs > 0 then
        return defconfigs[1]
    end

    return nil
end

function M.resolve_defconfig_target(defconfig_path)
    if defconfig_path == nil then
        return nil
    end

    local basename = defconfig_path:match("([^/]+)$")
    if basename == nil then
        return nil
    end

    return basename:gsub("_defconfig$", "") .. "_defconfig"
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    return M.resolve_defconfig(ctx, root, nil)
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local defconfig = M.resolve_defconfig(ctx, root, cfg.defconfig)
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local config_in = ctx.glob({ "Config.in", "**/Config.in" })
    local defconfigs = ctx.glob({ "**/*defconfig" })

    if not M.has_config_in(ctx, root) and #config_in == 0 and #defconfigs == 0 then
        error("buildroot plugin: no Config.in or defconfig found — add Buildroot project files or set defconfig in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/buildroot/bin"
    local output_name = cfg.output_name or "build.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local defconfig_target = M.resolve_defconfig_target(defconfig)

    return {
        project_root = root,
        entry_source = entry_source,
        defconfig = defconfig,
        defconfig_target = defconfig_target,
        has_config_in = M.has_config_in(ctx, root) or #config_in > 0,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
