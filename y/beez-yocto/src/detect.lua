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

function M.find_local_conf(ctx, root)
    local prefix = glob_prefix(root)
    local files = ctx.glob({
        prefix .. "conf/local.conf",
        prefix .. "**/conf/local.conf",
    })
    if #files == 0 then
        return nil
    end
    sort_shallow_first(files)
    return files[1]
end

function M.resolve_entry_recipe(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local recipes = ctx.glob({
        prefix .. "**/*.bb",
        prefix .. "*.bb",
    })

    sort_shallow_first(recipes)

    if #recipes > 0 then
        return recipes[1]
    end

    local appends = ctx.glob({
        prefix .. "**/*.bbappend",
        prefix .. "*.bbappend",
    })

    sort_shallow_first(appends)

    if #appends > 0 then
        return appends[1]
    end

    return nil
end

function M.has_recipes(ctx, root)
    local prefix = glob_prefix(root)
    local recipes = ctx.glob({
        prefix .. "**/*.bb",
        prefix .. "**/*.bbappend",
    })
    return #recipes > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local local_conf = M.find_local_conf(ctx, root)
    local entry_recipe = M.resolve_entry_recipe(ctx, root, cfg.entry_recipe)
    local marker_files = ctx.glob({
        "conf/local.conf",
        "**/conf/local.conf",
        "**/*.bb",
        "**/*.bbappend",
    })

    if local_conf == nil and entry_recipe == nil and #marker_files == 0 then
        error("yocto plugin: no conf/local.conf, *.bb, or *.bbappend files found — add Yocto sources or set project_root in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/yocto/bin"
    local output_name = cfg.output_name or "parse.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local has_recipes = cfg.has_recipes
    if has_recipes == nil then
        has_recipes = M.has_recipes(ctx, root)
    end

    return {
        project_root = root,
        local_conf = local_conf,
        entry_recipe = entry_recipe,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_recipes = has_recipes,
        has_local_conf = local_conf ~= nil,
    }
end

return M
