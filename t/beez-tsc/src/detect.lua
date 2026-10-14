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

function M.find_tsconfig(ctx)
    local files = ctx.glob({ "tsconfig.json", "**/tsconfig.json" })
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
    return files[1]
end

function M.project_root(tsconfig_path, package_json_path)
    if tsconfig_path ~= nil then
        return dirname(tsconfig_path)
    end
    if package_json_path ~= nil then
        return dirname(package_json_path)
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

function M.resolve_build_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/index.ts",
        prefix .. "src/index.tsx",
        prefix .. "src/main.ts",
        prefix .. "src/main.tsx",
        prefix .. "index.ts",
        prefix .. "index.tsx",
        prefix .. "main.ts",
        prefix .. "main.tsx",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                targets[#targets + 1] = { source = source }
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.ts", prefix .. "src/*.tsx" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/tests/") and not source:match("/test/") and not source:match("%.d%.ts$") then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.ts", prefix .. "*.tsx" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not source:match("%.d%.ts$") then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local tsconfig_path = cfg.tsconfig_path
    if tsconfig_path == nil then
        tsconfig_path = M.find_tsconfig(ctx)
    end

    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local ts_files = ctx.glob({ "**/*.ts", "**/*.tsx" })
    if tsconfig_path == nil and package_json_path == nil and #ts_files == 0 then
        error("tsc plugin: no tsconfig.json, package.json, or *.ts/*.tsx files found — add a TypeScript project or set tsconfig_path in configure()")
    end

    local root = cfg.project_root or M.project_root(tsconfig_path, package_json_path)
    local package_name = cfg.package_name or M.package_name(package_json_path)
    local dist_dir = cfg.dist_dir or "build/tsc/dist"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    if tsconfig_path == nil and #targets == 0 then
        error("tsc plugin: no tsconfig.json or .ts/.tsx entry point found — add tsconfig.json or src/index.ts")
    end

    return {
        tsconfig_path = tsconfig_path,
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        has_tsconfig = tsconfig_path ~= nil,
        project_root = root,
        package_name = package_name,
        targets = targets,
        dist_dir = dist_dir,
        primary_source = targets[1] and targets[1].source or nil,
    }
end

return M
