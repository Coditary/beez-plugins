local M = {}

local function basename(path)
    return path:match("([^/]+)$") or path
end

local function stem(path)
    local name = basename(path)
    return name:match("^(.+)%.[^%.]+$") or name
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
        or path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
end

function M.find_manifest(ctx)
    local files = ctx.glob({"Mercury.options", "**/Mercury.options"})
    if #files == 0 then
        return nil
    end
    table.sort(files)
    return files[1]
end

function M.find_sources(ctx)
    local sources = ctx.glob({"**/*.m"})
    sort_shallow_first(sources)
    return sources
end

function M.resolve_project_root(sources)
    if #sources == 0 then
        return "."
    end

    local shallowest = sources[1]
    local shallowest_depth = select(2, shallowest:gsub("/", ""))

    for i = 2, #sources do
        local depth = select(2, sources[i]:gsub("/", ""))
        if depth < shallowest_depth then
            shallowest = sources[i]
            shallowest_depth = depth
        end
    end

    return dirname(shallowest)
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.m",
        prefix .. "src/main.m",
        prefix .. package_name .. ".m",
        prefix .. "src/" .. package_name .. ".m",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = stem(source),
                    output = nil,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local all_sources = M.find_sources(ctx)
        local non_test = {}
        for _, source_path in ipairs(all_sources) do
            if not is_test_path(source_path) then
                non_test[#non_test + 1] = source_path
            end
        end

        if #non_test == 1 then
            targets[#targets + 1] = {
                source = non_test[1],
                name = stem(non_test[1]),
                output = nil,
            }
        elseif #non_test > 1 then
            for _, source_path in ipairs(non_test) do
                if not seen[source_path] then
                    seen[source_path] = true
                    targets[#targets + 1] = {
                        source = source_path,
                        name = stem(source_path),
                        output = nil,
                    }
                end
            end
        end
    end

    if #targets == 0 then
        error("mercury plugin: no build targets found — add *.m sources or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local source_files = ctx.glob({"**/*.m"})

    local manifest_files = ctx.glob({"Mercury.options", "**/Mercury.options"})
    if #source_files == 0 and #manifest_files == 0 then
        error("mercury plugin: no source or manifest files found — add **/*.m or configure targets")
    end

    local manifest_path = cfg.manifest_path
    if manifest_path == nil then
        manifest_path = M.find_manifest(ctx)
    end

    local root = cfg.project_root
    if root == nil then
        root = M.resolve_project_root(source_files)
    end

    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/mercury/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        manifest_path = manifest_path,
        has_manifest = manifest_path ~= nil,
    }
end

return M
