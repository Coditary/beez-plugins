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

function M.find_swcrc(ctx)
    local files = ctx.glob({ ".swcrc", "**/.swcrc" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
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

function M.has_typescript_sources(ctx, root)
    local prefix = glob_prefix(root)
    local ts_files = ctx.glob({ prefix .. "**/*.ts", prefix .. "**/*.tsx" })
    for _, path in ipairs(ts_files) do
        if not path:match("/node_modules/")
            and not path:match("/build/")
            and not path:match("/dist/")
            and not path:match("/%.d%.ts$") then
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
        local dir = candidate
        if candidate ~= "." then
            dir = prefix .. candidate
        else
            dir = root
            if root == "." or root == "" then
                dir = "."
            end
        end

        local pattern_prefix = dir
        if dir ~= "." then
            pattern_prefix = dir
        else
            pattern_prefix = prefix
            if pattern_prefix == "" then
                pattern_prefix = ""
            end
        end

        local patterns
        if dir == "." then
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

    error("swc plugin: no TypeScript/JavaScript sources found — add src/**/*.ts or set source_dir in configure()")
end

function M.resolve(ctx, cfg)
    local swcrc_path = cfg.swcrc_path
    if swcrc_path == nil then
        swcrc_path = M.find_swcrc(ctx)
    end

    local package_json = cfg.package_json
    if package_json == nil then
        package_json = M.find_package_json(ctx)
    end

    local root = cfg.project_root
    if root == nil then
        if swcrc_path ~= nil then
            root = dirname(swcrc_path)
        elseif package_json ~= nil then
            root = dirname(package_json)
        else
            root = "."
        end
    end

    local has_ts = M.has_typescript_sources(ctx, root)
    if swcrc_path == nil and package_json == nil and not has_ts then
        error("swc plugin: no .swcrc, package.json, or **/*.ts/**/*.tsx found — add a TypeScript project or set project_root in configure()")
    end

    local source_dir = M.resolve_source_dir(ctx, root, cfg.source_dir)
    local build_dir = cfg.build_dir or "build/swc"

    return {
        swcrc_path = swcrc_path,
        package_json = package_json,
        has_package_json = package_json ~= nil,
        project_root = root,
        source_dir = source_dir,
        build_dir = build_dir,
        bin_dir = cfg.bin_dir or build_dir,
        primary_output = build_dir,
    }
end

return M
