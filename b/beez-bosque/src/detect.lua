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
        or path:match("%.bsqtest$") ~= nil
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

function M.package_name(manifest_path, source_path, fallback)
    if manifest_path ~= nil then
        local name = basename(manifest_path):match("^(.+)%.[^%.]+$")
        if name == "package" then
            return fallback or "app"
        end
    end
    if source_path ~= nil then
        local name = basename(source_path):match("^(.+)%.bsq$")
        if name ~= nil then
            return name
        end
    end
    return fallback or "app"
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.bsq",
        prefix .. "src/main.bsq",
        prefix .. package_name .. ".bsq",
        prefix .. "src/" .. package_name .. ".bsq",
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
        local src_files = ctx.glob({ prefix .. "**/*.bsq" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+)%.bsq$") or package_name
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
        error("bosque plugin: no .bsq entry point found — add main.bsq or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local sources = ctx.glob({ "**/*.bsq" })
    local manifest_path = M.find_manifest(ctx, "package.json")

    if #sources == 0 and manifest_path == nil then
        error("bosque plugin: no source files found — add **/*.bsq or package.json or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(manifest_path, sources[1])
    local output_name = cfg.output_name or M.package_name(manifest_path, sources[1], "app")
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/bosque/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        manifest_path = manifest_path,
        has_manifest = manifest_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
