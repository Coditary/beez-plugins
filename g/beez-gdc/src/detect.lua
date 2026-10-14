local M = {}

local function basename(path)
    return path:match("([^/]+)$") or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

function M.find_dub_manifest(ctx)
    local manifests = ctx.glob({ "dub.json", "dub.sdl", "**/dub.json", "**/dub.sdl" })
    if #manifests == 0 then
        return nil
    end

    table.sort(manifests)
    return manifests[1]
end

function M.has_d_sources(ctx)
    return #ctx.glob({ "**/*.d" }) > 0
end

function M.project_root(manifest_path)
    if manifest_path == nil then
        return "."
    end
    return dirname(manifest_path)
end

function M.resolve_plain_sources(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local candidates = ctx.glob({
        prefix .. "source/app.d",
        prefix .. "source/main.d",
        prefix .. "app.d",
        prefix .. "main.d",
    })

    if #candidates > 0 then
        table.sort(candidates)
        local main_path = candidates[1]
        local main_dir = dirname(main_path)
        local sources = ctx.glob({ main_dir .. "/*.d", main_dir .. "/**/*.d" })
        if #sources == 0 then
            sources = { main_path }
        end
        return sources, basename(main_path):gsub("%.d$", "")
    end

    local sources = ctx.glob({ prefix .. "source/**/*.d", prefix .. "**/*.d" })
    if #sources == 0 then
        return nil, nil
    end

    table.sort(sources)
    return sources, "app"
end

function M.resolve_build_targets(ctx, root, cfg)
    local bin_dir = cfg.bin_dir or "build/gdc/bin"
    local output_name = cfg.output_name or "app"
    local manifest = cfg.dub_manifest

    if manifest ~= nil then
        return {
            {
                kind = "dub",
                name = output_name,
                output = bin_dir .. "/" .. output_name,
                manifest = manifest,
            },
        }
    end

    local sources, name = M.resolve_plain_sources(ctx, root)
    if sources == nil then
        error("gdc plugin: no dub manifest or .d sources found")
    end

    return {
        {
            kind = "plain",
            name = name or output_name,
            output = bin_dir .. "/" .. (name or output_name),
            sources = sources,
        },
    }
end

function M.resolve(ctx, cfg)
    cfg = cfg or {}

    local manifest = cfg.dub_manifest or M.find_dub_manifest(ctx)
    local root = cfg.project_root or M.project_root(manifest)

    if manifest == nil and not M.has_d_sources(ctx) then
        error("gdc plugin: no dub.json, dub.sdl, or .d sources found — add a D project or set dub_manifest in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/gdc/bin"
    local targets = cfg.targets or M.resolve_build_targets(ctx, root, {
        bin_dir = bin_dir,
        output_name = cfg.output_name,
        dub_manifest = manifest,
    })

    return {
        dub_manifest = manifest,
        project_root = root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        uses_dub = manifest ~= nil,
    }
end

return M
