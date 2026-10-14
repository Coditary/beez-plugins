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
        or path:match("%.test%.js$") ~= nil
        or path:match("%.spec%.js$") ~= nil
end

function M.find_package_json(ctx)
    local files = ctx.glob({ "package.json", "**/package.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
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

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.js$")
    return name or fallback or "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root, package_name)
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
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                }
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
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.js" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                }
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

    local js_files = ctx.glob({ "**/*.js" })
    if package_json_path == nil and #js_files == 0 then
        error("jsc plugin: no package.json or *.js files found — add a JavaScript project or set package_json_path in configure()")
    end

    local package_name = cfg.package_name or M.package_name(package_json_path)
    local root = cfg.project_root
    if root == nil then
        root = M.project_root(package_json_path, js_files[1])
    end

    local dist_dir = cfg.dist_dir or "build/jsc/dist"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, package_name)
    end

    if #targets == 0 then
        error("jsc plugin: no JavaScript entry point found — add src/index.js or configure targets")
    end

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = dist_dir .. "/" .. target.name .. ".jsc"
        end
    end

    return {
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        project_root = root,
        package_name = package_name,
        targets = targets,
        dist_dir = dist_dir,
        primary_source = targets[1].source,
        primary_output = targets[1].output,
    }
end

return M
