local M = {}

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

function M.find_spago_manifest(ctx)
    local files = ctx.glob({
        "spago.yaml",
        "spago.dhall",
        "**/spago.yaml",
        "**/spago.dhall",
    })
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

function M.project_root(spago_path, package_json_path)
    if spago_path ~= nil then
        return dirname(spago_path)
    end
    if package_json_path ~= nil then
        return dirname(package_json_path)
    end
    return "."
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.collect_purs_sources(ctx, root)
    local prefix = glob_prefix(root)
    local files = ctx.glob({ prefix .. "src/**/*.purs", prefix .. "**/*.purs" })
    sort_shallow_first(files)

    local sources = {}
    local seen = {}
    for _, source in ipairs(files) do
        if not source:match("/test/") and not source:match("/tests/") and not seen[source] then
            seen[source] = true
            sources[#sources + 1] = source
        end
    end

    return sources
end

function M.resolve(ctx, cfg)
    local spago_path = cfg.spago_path
    if spago_path == nil then
        spago_path = M.find_spago_manifest(ctx)
    end

    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local purs_files = ctx.glob({ "**/*.purs" })
    if spago_path == nil and package_json_path == nil and #purs_files == 0 then
        error("purescript plugin: no spago.yaml, spago.dhall, package.json, or *.purs files found")
    end

    local root = cfg.project_root or M.project_root(spago_path, package_json_path)
    local output_dir = cfg.output_dir or "build/purescript/output"
    local output_name = cfg.output_name or "app.js"
    local primary_output = output_dir .. "/" .. output_name
    local purs_sources = cfg.purs_sources or M.collect_purs_sources(ctx, root)

    return {
        spago_path = spago_path,
        has_spago = spago_path ~= nil,
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        project_root = root,
        purs_sources = purs_sources,
        output_dir = output_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
