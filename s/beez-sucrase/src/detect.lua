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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_package_json(ctx)
    local files = ctx.glob({ "package.json", "**/package.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    for _, path in ipairs(files) do
        if not path:match("/node_modules/") then
            return path
        end
    end

    return files[1]
end

function M.project_root(package_json_path)
    if package_json_path ~= nil then
        return dirname(package_json_path)
    end
    return "."
end

function M.has_typescript_sources(ctx, root)
    local prefix = glob_prefix(root)
    local ts_files = ctx.glob({ prefix .. "**/*.ts", prefix .. "**/*.tsx" })
    for _, path in ipairs(ts_files) do
        if not path:match("/node_modules/")
            and not path:match("/build/")
            and not path:match("/dist/")
            and not path:match("%.d%.ts$") then
            return true
        end
    end
    return false
end

function M.resolve_source_dir(ctx, root, cfg_source_dir)
    if cfg_source_dir ~= nil and cfg_source_dir ~= "" then
        return cfg_source_dir
    end

    local prefix = glob_prefix(root)
    local candidates = { "src", "lib", "app", "." }

    for _, candidate in ipairs(candidates) do
        local pattern_prefix
        if candidate == "." then
            pattern_prefix = prefix
        else
            pattern_prefix = prefix .. candidate
        end

        local patterns
        if candidate == "." then
            patterns = { prefix .. "**/*.ts", prefix .. "**/*.tsx" }
        else
            patterns = { pattern_prefix .. "/**/*.ts", pattern_prefix .. "/**/*.tsx" }
        end

        local matches = ctx.glob(patterns)
        for _, path in ipairs(matches) do
            if not path:match("/node_modules/")
                and not path:match("/build/")
                and not path:match("/dist/")
                and not path:match("/%.d%.ts$") then
                return candidate
            end
        end
    end

    error("sucrase plugin: no TypeScript sources found — add src/**/*.ts or set source_dir in configure()")
end

function M.resolve(ctx, cfg)
    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local ts_files = ctx.glob({ "**/*.ts", "**/*.tsx" })
    if package_json_path == nil and #ts_files == 0 then
        error("sucrase plugin: no package.json or **/*.ts/**.tsx files found — add a TypeScript project or set package_json_path in configure()")
    end

    local root = cfg.project_root or M.project_root(package_json_path)
    local source_dir = M.resolve_source_dir(ctx, root, cfg.source_dir)
    local dist_dir = cfg.dist_dir or "build/sucrase"

    return {
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        project_root = root,
        source_dir = source_dir,
        dist_dir = dist_dir,
        primary_output = dist_dir,
    }
end

return M
