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
end

function M.project_root(manifest_path)
    if manifest_path == nil then
        return "."
    end
    return dirname(manifest_path)
end

function M.package_name(manifest_path, source_path)
    if manifest_path ~= nil then
        local name = basename(manifest_path):match("^(.+)%.[^%.]+$")
        if name ~= nil then
            return name
        end
    end
    if source_path ~= nil then
        local name = basename(source_path):match("^(.+).bas$")
        if name ~= nil then
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

function M.resolve_build_targets(ctx, root, manifest_path, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or M.package_name(manifest_path, nil)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.bas",
        prefix .. "src/main.bas",
        prefix .. package_name .. ".bas",
        prefix .. "src/" .. package_name .. ".bas",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
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
        local src_files = ctx.glob({ "**/*.bas" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+).bas$") or package_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("qbasic plugin: no .bas entry point found — add main.bas or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)

    local manifest_path = nil

    local sources = ctx.glob({ "**/*.bas" })
    if manifest_path == nil and #sources == 0 then
        error("qbasic plugin: no source files found — add project markers or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(manifest_path)
    local output_name = cfg.output_name or M.package_name(manifest_path, sources[1])
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, manifest_path, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/qbasic/bin"
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
        manifest_path = nil,
        has_manifest = false,
    }
end

return M
