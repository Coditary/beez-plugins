local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

function M.find_dub_manifest(ctx)
    local manifests = ctx.glob({
        "dub.json",
        "dub.sdl",
        "**/dub.json",
        "**/dub.sdl",
    })

    if #manifests == 0 then
        return nil
    end

    table.sort(manifests, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return manifests[1]
end

function M.find_d_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    return ctx.glob({
        prefix .. "**/*.d",
    })
end

function M.resolve_entry_point(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local candidates = ctx.glob({
        prefix .. "source/app.d",
        prefix .. "source/main.d",
        prefix .. "src/app.d",
        prefix .. "src/main.d",
        prefix .. "app.d",
        prefix .. "main.d",
    })

    if #candidates > 0 then
        table.sort(candidates)
        return candidates[1]
    end

    local sources = M.find_d_sources(ctx, root)
    if #sources > 0 then
        table.sort(sources)
        return sources[1]
    end

    return nil
end

function M.project_root(manifest_or_entry)
    return dirname(manifest_or_entry)
end

function M.resolve_build_targets(ctx, cfg)
    local root = cfg.project_root
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/ldc/bin"
    local entry = cfg.entry_point

    if entry == nil then
        entry = M.resolve_entry_point(ctx, root)
    end

    if entry == nil then
        error("ldc plugin: no D source entry point found — add *.d sources or set entry_point in configure()")
    end

    local targets = {
        {
            entry = entry,
            name = output_name,
            output = bin_dir .. "/" .. output_name,
        },
    }

    return targets
end

function M.resolve(ctx, cfg)
    local dub_manifest = cfg.dub_manifest or M.find_dub_manifest(ctx)
    local use_dub = dub_manifest ~= nil

    local project_root
    if use_dub then
        project_root = cfg.project_root or M.project_root(dub_manifest)
    else
        local sources = M.find_d_sources(ctx, cfg.project_root or ".")
        if #sources == 0 then
            error("ldc plugin: no dub.json/dub.sdl or *.d sources found")
        end

        project_root = cfg.project_root or M.project_root(sources[1])
    end

    local targets = cfg.targets
    if targets == nil then
        targets = M.resolve_build_targets(ctx, {
            project_root = project_root,
            output_name = cfg.output_name,
            bin_dir = cfg.bin_dir,
            entry_point = cfg.entry_point,
        })
    end

    local bin_dir = cfg.bin_dir or "build/ldc/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or cfg.output_name or "app")
        end
    end

    return {
        dub_manifest = dub_manifest,
        use_dub = use_dub,
        project_root = project_root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_entry = targets[1].entry,
        target_name = targets[1].name,
    }
end

return M
