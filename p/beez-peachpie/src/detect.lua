local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

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

function M.find_phpproj(ctx)
    local projects = ctx.glob({ "*.phpproj", "**/*.phpproj" })
    if #projects == 0 then
        return nil
    end

    sort_shallow_first(projects)
    return projects[1]
end

function M.find_composer_json(ctx)
    local manifests = ctx.glob({ "composer.json", "**/composer.json" })
    if #manifests == 0 then
        return nil
    end

    sort_shallow_first(manifests)
    return manifests[1]
end

function M.find_source_files(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    return ctx.glob({
        prefix .. "**/*.php",
    })
end

function M.resolve_project(ctx, cfg)
    local phpproj = cfg.phpproj or cfg.project_file or M.find_phpproj(ctx)
    if phpproj ~= nil then
        return {
            project_file = phpproj,
            project_root = cfg.project_root or dirname(phpproj),
            project_kind = "phpproj",
        }
    end

    local composer = cfg.composer_json or M.find_composer_json(ctx)
    local root = cfg.project_root
    if composer ~= nil then
        root = root or dirname(composer)
    else
        root = root or "."
    end

    local sources = cfg.source_files
    if sources == nil then
        sources = M.find_source_files(ctx, root)
    end

    if #sources == 0 then
        error(
            "peachpie plugin: no *.phpproj, composer.json, or **/*.php found — "
                .. "add a Peachpie project or set project_file in configure()"
        )
    end

    error(
        "peachpie plugin: found PHP sources but no *.phpproj — "
            .. "create a Peachpie project with Peachpie.NET.Sdk or set phpproj in configure()"
    )
end

function M.resolve(ctx, cfg)
    local project = M.resolve_project(ctx, cfg)
    local build_dir = cfg.build_dir or "build/peachpie"

    return {
        project_file = project.project_file,
        project_root = project.project_root,
        project_kind = project.project_kind,
        build_dir = build_dir,
        bin_dir = cfg.bin_dir or build_dir,
        primary_output = build_dir,
    }
end

return M
