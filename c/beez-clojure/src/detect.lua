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

local function find_first(ctx, patterns)
    local matches = ctx.glob(patterns)
    if #matches == 0 then
        return nil
    end

    sort_shallow_first(matches)
    return matches[1]
end

function M.find_project_clj(ctx)
    return find_first(ctx, { "project.clj", "**/project.clj" })
end

function M.find_deps_edn(ctx)
    return find_first(ctx, { "deps.edn", "**/deps.edn" })
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_source_files(ctx, root)
    local prefix = glob_prefix(root)
    return ctx.glob({
        prefix .. "**/*.clj",
        prefix .. "**/*.cljc",
    })
end

function M.clj_path_to_namespace(path)
    local without_ext = path:gsub("%.clj[c]?$", "")
    local parts = {}
    for segment in without_ext:gmatch("[^/]+") do
        parts[#parts + 1] = segment:gsub("_", "-")
    end
    return table.concat(parts, ".")
end

function M.infer_namespaces(sources)
    local namespaces = {}
    for _, source in ipairs(sources) do
        namespaces[#namespaces + 1] = M.clj_path_to_namespace(source)
    end
    return namespaces
end

function M.is_test_path(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("^tests/") ~= nil
end

function M.resolve_project(ctx, cfg)
    local project_clj = cfg.project_clj or M.find_project_clj(ctx)
    if project_clj ~= nil then
        return {
            project_file = project_clj,
            project_root = cfg.project_root or dirname(project_clj),
            project_kind = "project.clj",
        }
    end

    local deps_edn = cfg.deps_edn or M.find_deps_edn(ctx)
    if deps_edn ~= nil then
        return {
            project_file = deps_edn,
            project_root = cfg.project_root or dirname(deps_edn),
            project_kind = "deps.edn",
        }
    end

    local root = cfg.project_root or "."
    local sources = cfg.source_files
    if sources == nil then
        sources = M.find_source_files(ctx, root)
    end

    if #sources == 0 then
        error("clojure plugin: no deps.edn, project.clj, or **/*.clj/**/*.cljc found — add a JVM Clojure project or set project_root in configure()")
    end

    return {
        project_file = nil,
        project_root = root,
        project_kind = "sources",
        source_files = sources,
        namespaces = M.infer_namespaces(sources),
    }
end

function M.resolve(ctx, cfg)
    local project = M.resolve_project(ctx, cfg)
    local build_dir = cfg.build_dir or "build/clojure"
    local output_name = cfg.output_name or "app"

    return {
        project_file = project.project_file,
        project_root = project.project_root,
        project_kind = project.project_kind,
        source_files = project.source_files,
        namespaces = project.namespaces,
        build_dir = build_dir,
        bin_dir = cfg.bin_dir or build_dir,
        primary_output = build_dir,
        output_name = output_name,
    }
end

return M
