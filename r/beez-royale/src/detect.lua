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

function M.find_asconfig(ctx)
    local configs = ctx.glob({ "asconfig.json", "**/asconfig.json" })
    if #configs == 0 then
        return nil
    end

    sort_shallow_first(configs)
    return configs[1]
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
        local name = basename(source_path):match("^(.+).as$")
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

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/Main.as",
        prefix .. "src/main.as",
        prefix .. "Main.as",
        prefix .. "main.as",
        prefix .. package_name .. ".as",
        prefix .. "src/" .. package_name .. ".as",
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
        local src_files = ctx.glob({ prefix .. "**/*.as" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+).as$") or package_name
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
        error("royale plugin: no .as entry point found — add Main.as or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local asconfig_path = cfg.asconfig or M.find_asconfig(ctx)
    local sources = ctx.glob({ "**/*.as" })

    if asconfig_path == nil and #sources == 0 then
        error("royale plugin: no asconfig.json or **/*.as found — add Royale project markers")
    end

    local root = cfg.project_root or M.project_root(asconfig_path)
    local output_name = cfg.output_name or M.package_name(asconfig_path, sources[1])
    local build_mode = asconfig_path ~= nil and "asconfig" or "sources"
    local targets = cfg.targets

    if build_mode == "sources" and targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/royale/bin"
    if targets ~= nil then
        for _, target in ipairs(targets) do
            if target.output == nil then
                target.output = bin_dir .. "/" .. (target.name or output_name) .. ".js"
            end
        end
    end

    local primary_output
    if build_mode == "asconfig" then
        primary_output = bin_dir
    else
        primary_output = targets[1].output
    end

    return {
        build_mode = build_mode,
        project_root = root,
        package_name = output_name,
        asconfig_path = asconfig_path,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = primary_output,
        primary_source = targets ~= nil and targets[1].source or nil,
    }
end

return M
