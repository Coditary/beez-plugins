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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_config(ctx, root, cfg_path)
    if cfg_path ~= nil and cfg_path ~= "" then
        return cfg_path
    end

    local prefix = glob_prefix(root)
    local configs = ctx.glob({
        prefix .. "sqlboiler.toml",
        prefix .. "**/sqlboiler.toml",
    })

    if #configs == 0 then
        return nil
    end

    sort_shallow_first(configs)
    return configs[1]
end

function M.find_go_mod(ctx, root)
    local prefix = glob_prefix(root)
    local mods = ctx.glob({
        prefix .. "go.mod",
        prefix .. "**/go.mod",
    })
    if #mods == 0 then
        return nil
    end
    sort_shallow_first(mods)
    return mods[1]
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local config_path = M.find_config(ctx, root, cfg.config_path)
    local go_mod = M.find_go_mod(ctx, root)
    local marker_files = ctx.glob({
        "sqlboiler.toml",
        "**/sqlboiler.toml",
    })

    if config_path == nil and #marker_files == 0 then
        error("sqlboiler plugin: no sqlboiler.toml found — add SQLBoiler config or set config_path in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/sqlboiler/bin"
    local output_name = cfg.output_name or "generate.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local output_dir = cfg.output_dir or "models"

    return {
        project_root = root,
        config_path = config_path,
        go_mod = go_mod,
        output_dir = output_dir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
