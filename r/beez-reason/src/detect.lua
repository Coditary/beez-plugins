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
        or path:match("^tests/") ~= nil
        or path:match("/__tests__/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(rescript_json_path, bsconfig_path)
    if rescript_json_path ~= nil then
        return dirname(rescript_json_path)
    end
    if bsconfig_path ~= nil then
        return dirname(bsconfig_path)
    end
    return "."
end

function M.package_name(rescript_json_path, bsconfig_path)
    local manifest = rescript_json_path or bsconfig_path
    if manifest ~= nil then
        local name = basename(dirname(manifest))
        if name ~= "." and name ~= "" then
            return name
        end
    end
    return "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_compile_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local patterns = {
        prefix .. "**/*.re",
        prefix .. "**/*.rei",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                local name = basename(source):match("^(.+)%.[^%.]+$") or basename(source)
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
            end
        end
    end

    if #targets == 0 then
        error("reason plugin: no .re or .rei source files found — add Reason sources or set project_root in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local rescript_json_path = cfg.rescript_json_path
    if rescript_json_path == nil then
        rescript_json_path = M.find_manifest(ctx, "rescript.json")
    end

    local bsconfig_path = cfg.bsconfig_path
    if bsconfig_path == nil then
        bsconfig_path = M.find_manifest(ctx, "bsconfig.json")
    end

    local re_files = ctx.glob({ "**/*.re" })
    local rei_files = ctx.glob({ "**/*.rei" })
    if rescript_json_path == nil and bsconfig_path == nil and #re_files == 0 and #rei_files == 0 then
        error("reason plugin: no rescript.json, bsconfig.json, or *.re/*.rei files found — add a Reason project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(rescript_json_path, bsconfig_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/reason"

    return {
        rescript_json_path = rescript_json_path,
        bsconfig_path = bsconfig_path,
        has_rescript_json = rescript_json_path ~= nil,
        has_bsconfig = bsconfig_path ~= nil,
        project_root = root,
        package_name = M.package_name(rescript_json_path, bsconfig_path),
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
    }
end

return M
