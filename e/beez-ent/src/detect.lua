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

function M.resolve_schema_dir(ctx, root, cfg_dir)
    if cfg_dir ~= nil and cfg_dir ~= "" then
        return cfg_dir
    end

    local prefix = glob_prefix(root)
    local schemas = ctx.glob({
        prefix .. "ent/schema/**/*.go",
        prefix .. "**/ent/schema/**/*.go",
    })

    if #schemas == 0 then
        return nil
    end

    sort_shallow_first(schemas)
    local schema_file = schemas[1]
    local schema_dir = schema_file:match("^(.*)/[^/]+$")
    if schema_dir == nil then
        return "ent/schema"
    end
    return schema_dir
end

function M.has_schema_files(ctx, root)
    local prefix = glob_prefix(root)
    local schemas = ctx.glob({
        prefix .. "ent/schema/**/*.go",
        prefix .. "**/ent/schema/**/*.go",
    })
    return #schemas > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local go_mod = M.find_go_mod(ctx, root)
    local schema_dir = M.resolve_schema_dir(ctx, root, cfg.ent_schema_dir)
    local marker_files = ctx.glob({
        "ent/schema/**/*.go",
        "**/ent/schema/**/*.go",
    })

    if schema_dir == nil and #marker_files == 0 then
        error("ent plugin: no ent/schema/**/*.go files found — add Ent schema sources or set ent_schema_dir in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/ent/bin"
    local output_name = cfg.output_name or "generate.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local ent_output_dir = cfg.ent_output_dir
    if ent_output_dir == nil and schema_dir ~= nil then
        ent_output_dir = schema_dir:match("^(.*)/schema$") or "ent"
    end

    return {
        project_root = root,
        go_mod = go_mod,
        ent_schema_dir = schema_dir or "ent/schema",
        ent_output_dir = ent_output_dir or "ent",
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_schema_files = M.has_schema_files(ctx, root),
    }
end

return M
