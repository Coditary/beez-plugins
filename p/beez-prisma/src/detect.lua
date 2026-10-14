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

function M.resolve_schema(ctx, root, cfg_schema)
    if cfg_schema ~= nil and cfg_schema ~= "" then
        return cfg_schema
    end

    local prefix = glob_prefix(root)
    local schemas = ctx.glob({
        prefix .. "schema.prisma",
        prefix .. "**/schema.prisma",
    })

    if #schemas == 0 then
        return nil
    end

    sort_shallow_first(schemas)
    return schemas[1]
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local schema_path = M.resolve_schema(ctx, root, cfg.schema_path)
    local marker_files = ctx.glob({
        "schema.prisma",
        "**/schema.prisma",
    })

    if schema_path == nil and #marker_files == 0 then
        error("prisma plugin: no schema.prisma found — add a Prisma schema or set schema_path in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/prisma/bin"
    local output_name = cfg.output_name or "generate.ok"
    local primary_output = bin_dir .. "/" .. output_name

    return {
        project_root = root,
        schema_path = schema_path,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
