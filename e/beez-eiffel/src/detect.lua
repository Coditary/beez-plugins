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
        prefix .. "**/*.e",
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
    local source_files_0 = ctx.glob({ "**/*.e" })

    local manifest_path = cfg.manifest_path
    if manifest_path == nil then
        manifest_path = M.find_manifest(ctx, {
            "*.ecf",
            "**/*.ecf",
        })
    end

    if (#source_files_0 == 0 and manifest_path == nil) then
        error("eiffel plugin: no **/*.e files found or manifest — add a Eiffel project or set project_root in configure()")
    end
    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end
    if #targets == 0 and manifest_path ~= nil then
        targets = {{
            {
                source = manifest_path,
                name = output_name,
                output = nil,
            },
        }}
    end

    if #targets == 0 then
        error("{name} plugin: no source files found — add {p['title']} sources or configure targets")
    end
    local bin_dir = cfg.bin_dir or "build/eiffel"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name
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
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        has_test_dir = test_dir ~= nil,
        test_dir = test_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        manifest_path = manifest_path,
        has_manifest = manifest_path ~= nil,
    }
end

return M
