local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function depth(path)
    return select(2, path:gsub("/", ""))
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = depth(a)
        local depth_b = depth(b)
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

function M.find_dune_build(ctx)
    local projects = ctx.glob({ "dune-project", "**/dune-project" })
    if #projects > 0 then
        sort_shallow_first(projects)
        return projects[1], "dune"
    end

    local dune_files = ctx.glob({ "dune", "**/dune" })
    if #dune_files > 0 then
        sort_shallow_first(dune_files)
        return dune_files[1], "dune"
    end

    return nil, nil
end

function M.package_name(project_root)
    if project_root == nil or project_root == "." or project_root == "" then
        return "app"
    end

    return basename(project_root)
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    local roots = {
        prefix .. "bin",
        prefix .. "lib",
        prefix .. "src",
        prefix,
    }

    local sources = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({ root .. "/**/*.ml", root .. "/*.ml" })
        for _, file in ipairs(files) do
            if not seen[file] then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
        if #sources > 0 then
            break
        end
    end

    if #sources == 0 then
        local all = ctx.glob({ prefix .. "**/*.ml" })
        for _, file in ipairs(all) do
            if not file:match("/_build/")
                and not file:match("/%.opam/")
                and not file:match("/test/")
                and not file:match("/tests/") then
                sources[#sources + 1] = file
            end
        end
    end

    return sources
end

function M.resolve_main_source(sources)
    for _, source in ipairs(sources) do
        if source:match("/main%.ml$") or source:match("/Main%.ml$") then
            return source
        end
    end

    for _, source in ipairs(sources) do
        if source:match("/bin/") then
            return source
        end
    end

    if #sources > 0 then
        return sources[#sources]
    end

    return nil
end

function M.resolve(ctx, cfg)
    local dune_build = cfg.dune_build
    local backend = cfg.backend

    if dune_build == nil then
        dune_build = select(1, M.find_dune_build(ctx))
    end

    if backend == nil then
        backend = dune_build ~= nil and "dune" or "ocamlopt"
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if dune_build ~= nil then
            project_root = dirname(dune_build)
        else
            project_root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_roots(ctx, project_root)
    end

    if backend == "ocamlopt" and #sources == 0 then
        error("ocamlopt plugin: no OCaml sources found — add .ml files or a dune-project")
    end

    if backend == "dune" and dune_build == nil then
        error("ocamlopt plugin: dune backend selected but no dune-project / dune file found")
    end

    local output_name = cfg.output_name or "app"
    local obj_dir = cfg.obj_dir or "build/ocamlopt/obj"
    local bin_dir = cfg.bin_dir or "build/ocamlopt/bin"
    local package_name = cfg.package_name or M.package_name(project_root)

    return {
        backend = backend,
        dune_build = dune_build,
        project_root = project_root,
        package_name = package_name,
        sources = sources,
        main_source = M.resolve_main_source(sources),
        obj_dir = obj_dir,
        bin_dir = bin_dir,
        primary_output = bin_dir .. "/" .. output_name,
        native_output = bin_dir,
    }
end

return M
