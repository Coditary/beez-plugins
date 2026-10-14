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

function M.find_bsconfig(ctx)
    local files = ctx.glob({ "bsconfig.json", "**/bsconfig.json" })
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

function M.project_root(bsconfig_path, package_json_path)
    if bsconfig_path ~= nil then
        return dirname(bsconfig_path)
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

function M.resolve_source_roots(ctx, root)
    local prefix = glob_prefix(root)
    local sources = {}
    local seen = {}

    local patterns = {
        prefix .. "src/**/*.re",
        prefix .. "src/**/*.ml",
        prefix .. "src/**/*.rei",
        prefix .. "src/**/*.mli",
        prefix .. "**/*.re",
        prefix .. "**/*.ml",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not source:match("/lib/") and not source:match("/node_modules/") and not seen[source] then
                seen[source] = true
                sources[#sources + 1] = source
            end
        end
        if #sources > 0 then
            break
        end
    end

    return sources
end

function M.detect_native_backend(bsconfig_path)
    if bsconfig_path == nil then
        return false
    end

    local ok, file = pcall(io.open, bsconfig_path, "r")
    if not ok or file == nil then
        return false
    end

    local content = file:read("*a")
    file:close()

    if content == nil then
        return false
    end

    return content:match('"bs%-platform%-native"') ~= nil
        or content:match('"bsb%-native"') ~= nil
        or content:match('"package%-specs"%s*:%s*%[%s*%{[^%}]*"in%-source"%s*:%s*true')
end

function M.resolve(ctx, cfg)
    local bsconfig_path = cfg.bsconfig_path
    if bsconfig_path == nil then
        bsconfig_path = M.find_bsconfig(ctx)
    end

    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local ml_files = ctx.glob({ "**/*.ml", "**/*.mli" })
    local re_files = ctx.glob({ "**/*.re", "**/*.rei" })

    if bsconfig_path == nil and package_json_path == nil and #ml_files == 0 and #re_files == 0 then
        error("bucklescript plugin: no bsconfig.json, package.json, or *.ml/*.re files found — add a BuckleScript project or set bsconfig_path in configure()")
    end

    local root = cfg.project_root or M.project_root(bsconfig_path, package_json_path)
    local package_name = cfg.package_name or M.package_name(package_json_path)
    local js_dir = cfg.js_dir or "build/bucklescript/js"
    local bs_dir = cfg.bs_dir or "build/bucklescript/bs"
    local sources = cfg.sources

    if sources == nil then
        sources = M.resolve_source_roots(ctx, root)
    end

    if bsconfig_path == nil and #sources == 0 then
        error("bucklescript plugin: no bsconfig.json or .ml/.re source files found — add bsconfig.json or src/*.re")
    end

    local use_native = cfg.use_native
    if use_native == nil then
        use_native = M.detect_native_backend(bsconfig_path)
    end

    return {
        bsconfig_path = bsconfig_path,
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        has_bsconfig = bsconfig_path ~= nil,
        project_root = root,
        package_name = package_name,
        sources = sources,
        js_dir = js_dir,
        bs_dir = bs_dir,
        use_native = use_native,
        primary_source = sources[1],
    }
end

return M
