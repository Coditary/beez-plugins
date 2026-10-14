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

function M.resolve_containerfile(ctx, root, cfg_file)
    if cfg_file ~= nil and cfg_file ~= "" then
        return cfg_file
    end

    local prefix = glob_prefix(root)
    local containerfiles = ctx.glob({
        prefix .. "Containerfile",
        prefix .. "**/Containerfile",
    })
    if #containerfiles > 0 then
        sort_shallow_first(containerfiles)
        return containerfiles[1]
    end

    local dockerfiles = ctx.glob({
        prefix .. "Dockerfile",
        prefix .. "**/Dockerfile",
    })
    if #dockerfiles > 0 then
        sort_shallow_first(dockerfiles)
        return dockerfiles[1]
    end

    return nil
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local containerfile = M.resolve_containerfile(ctx, root, cfg.containerfile)
    local marker_files = ctx.glob({
        "Containerfile",
        "Dockerfile",
        "**/Containerfile",
        "**/Dockerfile",
    })

    if containerfile == nil and #marker_files == 0 then
        error("buildah plugin: no Containerfile or Dockerfile found — add a container build file or set containerfile in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/buildah/bin"
    local output_name = cfg.output_name or "image.ok"
    local primary_output = bin_dir .. "/" .. output_name

    return {
        project_root = root,
        containerfile = containerfile,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
