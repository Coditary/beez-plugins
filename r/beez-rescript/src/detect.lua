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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_rescript_json(ctx)
    local files = ctx.glob({ "rescript.json", "**/rescript.json" })
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

function M.project_root(rescript_json_path, package_json_path)
    if rescript_json_path ~= nil then
        return dirname(rescript_json_path)
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

function M.resolve_build_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/Main.res",
        prefix .. "src/App.res",
        prefix .. "src/Index.res",
        prefix .. "Main.res",
        prefix .. "App.res",
        prefix .. "Index.res",
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
        local src_files = ctx.glob({ prefix .. "src/*.res", prefix .. "*.res" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/tests/") and not source:match("/test/") then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local rescript_json_path = cfg.rescript_json_path
    if rescript_json_path == nil then
        rescript_json_path = M.find_rescript_json(ctx)
    end

    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local res_files = ctx.glob({ "**/*.res", "**/*.resi" })
    if rescript_json_path == nil and package_json_path == nil and #res_files == 0 then
        error("rescript plugin: no rescript.json, package.json, or *.res/*.resi files found — add a ReScript project or set rescript_json_path in configure()")
    end

    local root = cfg.project_root or M.project_root(rescript_json_path, package_json_path)
    local package_name = cfg.package_name or M.package_name(package_json_path)
    local dist_dir = cfg.dist_dir or "build/rescript/dist"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    if rescript_json_path == nil and #targets == 0 and #res_files == 0 then
        error("rescript plugin: no rescript.json or .res/.resi entry point found — add rescript.json or src/Main.res")
    end

    return {
        rescript_json_path = rescript_json_path,
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        has_rescript_json = rescript_json_path ~= nil,
        project_root = root,
        package_name = package_name,
        targets = targets,
        dist_dir = dist_dir,
        primary_source = targets[1] and targets[1].source or res_files[1],
    }
end

return M
