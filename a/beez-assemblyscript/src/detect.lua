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

function M.find_asconfig(ctx)
    local files = ctx.glob({ "asconfig.json", "**/asconfig.json" })
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

function M.project_root(asconfig_path, package_json_path)
    if asconfig_path ~= nil then
        return dirname(asconfig_path)
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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "assembly/index.ts",
        prefix .. "assembly/main.ts",
        prefix .. "index.ts",
        prefix .. "main.ts",
        prefix .. "src/index.ts",
        prefix .. "src/main.ts",
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
        local assembly_files = ctx.glob({ prefix .. "assembly/*.ts" })
        sort_shallow_first(assembly_files)
        for _, source in ipairs(assembly_files) do
            if not source:match("/tests/") and not source:match("/test/") and not source:match("%.d%.ts$") then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.ts" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/tests/") and not source:match("/test/") and not source:match("%.d%.ts$") then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.ts" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not source:match("%.d%.ts$") then
                targets[#targets + 1] = { source = source }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local asconfig_path = cfg.asconfig_path
    if asconfig_path == nil then
        asconfig_path = M.find_asconfig(ctx)
    end

    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local ts_files = ctx.glob({ "**/*.ts" })
    if asconfig_path == nil and package_json_path == nil and #ts_files == 0 then
        error("assemblyscript plugin: no asconfig.json, package.json, or *.ts files found — add an AssemblyScript project or set asconfig_path in configure()")
    end

    local root = cfg.project_root or M.project_root(asconfig_path, package_json_path)
    local package_name = cfg.package_name or M.package_name(package_json_path)
    local wasm_dir = cfg.wasm_dir or "build/assemblyscript/wasm"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    if asconfig_path == nil and #targets == 0 then
        error("assemblyscript plugin: no asconfig.json or .ts entry point found — add asconfig.json or assembly/index.ts")
    end

    local output_name = cfg.output_name
    if output_name == nil and targets[1] ~= nil then
        output_name = basename(targets[1].source):gsub("%.ts$", "")
    end
    if output_name == nil then
        output_name = package_name
    end

    return {
        asconfig_path = asconfig_path,
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        has_asconfig = asconfig_path ~= nil,
        project_root = root,
        package_name = package_name,
        targets = targets,
        wasm_dir = wasm_dir,
        output_name = output_name,
        primary_source = targets[1] and targets[1].source or nil,
    }
end

return M
