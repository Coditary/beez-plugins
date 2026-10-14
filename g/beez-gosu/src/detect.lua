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
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("Test%.gs$") ~= nil
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_manifest(ctx, patterns)
    for _, pattern in ipairs(patterns) do
        local files = ctx.glob({ pattern, "**/" .. pattern })
        if #files > 0 then
            sort_shallow_first(files)
            return files[1]
        end
    end
    return nil
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local patterns = {
        prefix .. "**/*.gs",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                local name = basename(source):match("^(.+)%.[^%.]+$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local source_files = ctx.glob({ "**/*.gs" })
    local manifest_path = cfg.manifest_path
    if manifest_path == nil then
        manifest_path = M.find_manifest(ctx, { "pom.xml", "**/pom.xml" })
    end

    if #source_files == 0 and manifest_path == nil then
        error("gosu plugin: no **/*.gs files found or pom.xml — add a Gosu project or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    if manifest_path ~= nil then
        root = dirname(manifest_path)
    end

    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    if #targets == 0 and manifest_path ~= nil then
        targets = {{
            source = manifest_path,
            name = output_name,
            output = nil,
        }}
    end

    if #targets == 0 then
        error("gosu plugin: no Gosu source files found — add **/*.gs or configure targets")
    end

    local bin_dir = cfg.bin_dir or "build/gosu"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name .. ".class"
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        manifest_path = manifest_path,
        has_manifest = manifest_path ~= nil,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
