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

function M.find_package_json(ctx)
    local files = ctx.glob({ "package.json", "**/package.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    for _, path in ipairs(files) do
        if not is_vendor_path(path) then
            return path
        end
    end

    return files[1]
end

function M.project_root(package_json_path, primary_source)
    if package_json_path ~= nil then
        return dirname(package_json_path)
    end
    if primary_source ~= nil then
        return dirname(primary_source)
    end
    return "."
end

function M.package_name(package_json_path)
    if package_json_path == nil then
        return "app"
    end

    return basename(dirname(package_json_path))
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.collect_sources(ctx, root)
    local prefix = glob_prefix(root)
    local patterns = {
        prefix .. "**/*.js",
        prefix .. "**/*.mjs",
    }

    local sources = {}
    local seen = {}

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) and not is_vendor_path(source) then
                seen[source] = true
                sources[#sources + 1] = source
            end
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
        prefix .. "src/index.mjs",
        prefix .. "src/main.js",
        prefix .. "src/main.mjs",
        prefix .. "index.js",
        prefix .. "index.mjs",
        prefix .. "main.js",
        prefix .. "main.mjs",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) and not is_vendor_path(source) then
                seen[source] = true
                targets[#targets + 1] = { source = source }
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.js", prefix .. "src/*.mjs" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) and not is_vendor_path(source) then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.js", prefix .. "*.mjs" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) and not is_vendor_path(source) then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local js_files = ctx.glob({ "**/*.js", "**/*.mjs" })
    local project_files = {}
    for _, path in ipairs(js_files) do
        if not is_vendor_path(path) then
            project_files[#project_files + 1] = path
        end
    end

    if package_json_path == nil and #project_files == 0 then
        error("v8 plugin: no package.json or *.js/*.mjs files found — add a JavaScript project or set package_json_path in configure()")
    end

    local entry_targets = cfg.targets
    if entry_targets == nil then
        local root_guess = cfg.project_root
        if root_guess == nil and package_json_path ~= nil then
            root_guess = dirname(package_json_path)
        end
        entry_targets = M.resolve_build_targets(ctx, root_guess or ".")
    end

    local primary_source = entry_targets[1] and entry_targets[1].source or project_files[1]
    local root = cfg.project_root or M.project_root(package_json_path, primary_source)
    local package_name = cfg.package_name or M.package_name(package_json_path)
    local dist_dir = cfg.dist_dir or "build/v8/dist"
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
        error("v8 plugin: no JavaScript entry point found — add index.js, src/main.js, or configure targets")
    end

    return {
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        project_root = root,
        package_name = package_name,
        targets = entry_targets,
        sources = sources,
        dist_dir = dist_dir,
        primary_source = primary_source,
    }
end

return M
