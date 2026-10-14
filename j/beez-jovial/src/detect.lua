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
    return path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end
    sort_shallow_first(files)
    return files[1]
end

function M.project_root(manifest_path, first_source)
    if manifest_path ~= nil then
        return dirname(manifest_path)
    end
    if first_source ~= nil then
        return dirname(first_source)
    end
    return "."
end

function M.package_name(manifest_path, first_source, fallback)
    if manifest_path ~= nil then
        local name = basename(dirname(manifest_path))
        if name ~= "." and name ~= "" then
            return name
        end
    end
    if first_source ~= nil then
        local name = basename(first_source):match("^(.+)%.[^%.]+$")
        if name ~= nil and name ~= "" then
            return name
        end
    end
    return fallback or "app"
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local patterns = {
        prefix .. "**/*.jov"
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
        error("jovial plugin: no source files found — add *.jov sources or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local marker_patterns = {
        "**/*.jov"
    }
    local found = false
    for _, pattern in ipairs(marker_patterns) do
        if #ctx.glob({ pattern }) > 0 then
            found = true
            break
        end
    end
    if not found then
        error("jovial plugin: no project markers found — add *.jov sources or set project_root in configure()")
    end

    local manifest_path = cfg.manifest_path
    if manifest_path == nil and "" ~= "" then
        manifest_path = M.find_manifest(ctx, "")
    end

    local root = cfg.project_root or M.project_root(manifest_path, nil)
    local output_name = cfg.output_name or M.package_name(manifest_path, nil, "app")
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/jovial"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name .. ".o"
        end
    end

    local test_dir = nil
    local test_dirs = ctx.glob({ "t", "t/**", root .. "/t", root .. "/t/**" })
    if #test_dirs > 0 then
        test_dir = "t"
        if root ~= "." and root ~= "" then
            test_dir = root .. "/t"
        end
    end

    return {
        manifest_path = manifest_path,
        has_manifest = manifest_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        has_test_dir = test_dir ~= nil,
        test_dir = test_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
