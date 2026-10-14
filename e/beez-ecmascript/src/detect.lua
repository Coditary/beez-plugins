local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

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

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("/__tests__/") ~= nil
        or path:match("%.test%.") ~= nil
        or path:match("%.spec%.") ~= nil
end

local function is_vendor_path(path)
    return path:match("/node_modules/") ~= nil
        or path:match("^node_modules/") ~= nil
end

local function is_typescript_path(path)
    return path:match("%.ts$") ~= nil
        or path:match("%.tsx$") ~= nil
        or path:match("%.mts$") ~= nil
        or path:match("%.cts$") ~= nil
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.[^%.]+$")
    return name or fallback or "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.collect_sources(ctx, root)
    local prefix = glob_prefix(root)
    local matches = ctx.glob({ prefix .. "**/*.js" })
    local sources = {}
    local seen = {}

    for _, source in ipairs(matches) do
        if not seen[source]
            and not is_test_path(source)
            and not is_vendor_path(source)
            and not is_typescript_path(source) then
            seen[source] = true
            sources[#sources + 1] = source
        end
    end

    sort_shallow_first(sources)
    return sources
end

function M.resolve_build_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/index.js",
        prefix .. "src/main.js",
        prefix .. "index.js",
        prefix .. "main.js",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source]
                and not is_test_path(source)
                and not is_vendor_path(source)
                and not is_typescript_path(source) then
                seen[source] = true
                targets[#targets + 1] = { source = source }
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.js" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) and not is_vendor_path(source) and not is_typescript_path(source) then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.js" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) and not is_vendor_path(source) and not is_typescript_path(source) then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local js_files = ctx.glob({ "**/*.js" })
    local project_files = {}
    for _, path in ipairs(js_files) do
        if not is_vendor_path(path) and not is_typescript_path(path) then
            project_files[#project_files + 1] = path
        end
    end

    if #project_files == 0 then
        error("ecmascript plugin: no *.js files found — add JavaScript sources or set project_root in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        root = dirname(project_files[1])
    end

    local entry_targets = cfg.targets
    if entry_targets == nil then
        entry_targets = M.resolve_build_targets(ctx, root)
    end

    local primary_source = entry_targets[1] and entry_targets[1].source or project_files[1]
    local package_name = cfg.package_name or M.entry_name(primary_source, "app")
    local dist_dir = cfg.dist_dir or "build/ecmascript/dist"
    local sources = cfg.sources

    if sources == nil then
        sources = M.collect_sources(ctx, root)
    end

    if #sources == 0 and #entry_targets > 0 then
        for _, target in ipairs(entry_targets) do
            sources[#sources + 1] = target.source
        end
    end

    if #sources == 0 then
        error("ecmascript plugin: no JavaScript entry point found — add index.js, src/main.js, or configure targets")
    end

    return {
        project_root = root,
        package_name = package_name,
        targets = entry_targets,
        sources = sources,
        dist_dir = dist_dir,
        primary_source = primary_source,
    }
end

return M
