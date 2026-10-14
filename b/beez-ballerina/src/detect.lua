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
        or path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end
    sort_shallow_first(files)
    return files[1]
end

function M.project_root(manifest_path)
    if manifest_path ~= nil then
        return dirname(manifest_path)
    end
    return "."
end

function M.package_name(manifest_path, fallback)
    if manifest_path ~= nil then
        local name = basename(dirname(manifest_path))
        if name ~= "." and name ~= "" then
            return name
        end
    end
    return fallback or "app"
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
        prefix .. "**/*.bal",
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
        error("ballerina plugin: no compile targets found — add source files or set targets in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local ext_bal_files = ctx.glob({ "**/*.bal" })
    local manifest_path = cfg.manifest_path
    if manifest_path == nil then
        manifest_path = M.find_manifest(ctx, "Ballerina.toml")
    end

    if manifest_path == nil and not (#ext_bal_files > 0) then
        error("ballerina plugin: no Ballerina.toml or source files found — add project markers or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(manifest_path)

    local output_name = cfg.output_name or M.package_name(manifest_path, "app")
    local targets = cfg.targets
    local project_compile = false

    if targets == nil then
        if "project" == "project" then
            project_compile = true
            targets = { {
                source = manifest_path or root,
                name = output_name,
                output = nil,
            } }
        else
            targets = M.resolve_compile_targets(ctx, root)
        end
    end

    local bin_dir = cfg.bin_dir or "build/ballerina"

    return {
        manifest_path = manifest_path,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
        project_compile = project_compile,
    }
end

return M
