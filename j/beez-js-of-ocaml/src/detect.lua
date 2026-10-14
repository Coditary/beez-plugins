local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
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

function M.find_dune_project(ctx)
    local projects = ctx.glob({ "dune-project", "**/dune-project" })
    if #projects > 0 then
        sort_shallow_first(projects)
        return projects[1]
    end

    return nil
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    local roots = {
        prefix .. "src",
        prefix .. "lib",
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
            if not file:match("/_build/") and not file:match("/%.opam/") then
                sources[#sources + 1] = file
            end
        end
    end

    return sources
end

function M.resolve(ctx, cfg)
    local dune_project = cfg.dune_project
    local backend = cfg.backend

    if dune_project == nil then
        dune_project = M.find_dune_project(ctx)
    end

    if backend == nil then
        backend = dune_project ~= nil and "dune" or "js_of_ocaml"
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if dune_project ~= nil then
            project_root = dirname(dune_project)
        else
            project_root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_roots(ctx, project_root)
    end

    if backend == "js_of_ocaml" and #sources == 0 then
        error("js-of-ocaml plugin: no OCaml sources found — add .ml files or a dune-project")
    end

    if backend == "dune" and dune_project == nil then
        error("js-of-ocaml plugin: dune backend selected but no dune-project found")
    end

    local output_name = cfg.output_name or "main"
    local js_dir = cfg.js_dir or "build/js-of-ocaml/js"
    local bin_dir = cfg.bin_dir or "build/js-of-ocaml/bin"

    return {
        backend = backend,
        dune_project = dune_project,
        project_root = project_root,
        sources = sources,
        js_dir = js_dir,
        bin_dir = bin_dir,
        primary_output = js_dir .. "/" .. output_name .. ".js",
        js_output = js_dir,
    }
end

return M
