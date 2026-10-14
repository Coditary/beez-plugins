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
        or path:match("Test%.php$") ~= nil
        or path:match("Test%.hh$") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(composer_path, hhconfig_path)
    if composer_path ~= nil then
        return dirname(composer_path)
    end
    if hhconfig_path ~= nil then
        return dirname(hhconfig_path)
    end
    return "."
end

function M.package_name(composer_path)
    if composer_path ~= nil then
        local name = basename(dirname(composer_path))
        if name ~= "." and name ~= "" then
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

function M.resolve_entry_points(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "index.php",
        prefix .. "public/index.php",
        prefix .. "web/index.php",
        prefix .. "src/index.php",
        prefix .. "bin/app.php",
        prefix .. "main.php",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches
        end
    end

    local sources = ctx.glob({ prefix .. "**/*.php", prefix .. "**/*.hh" })
    sort_shallow_first(sources)
    local entry_points = {}
    for _, source in ipairs(sources) do
        if not is_test_path(source) then
            entry_points[#entry_points + 1] = source
            if #entry_points >= 8 then
                break
            end
        end
    end

    return entry_points
end

function M.resolve(ctx, cfg)
    local composer_path = cfg.composer_json
    if composer_path == nil then
        composer_path = M.find_manifest(ctx, "composer.json")
    end

    local hhconfig_path = cfg.hhconfig
    if hhconfig_path == nil then
        hhconfig_path = M.find_manifest(ctx, ".hhconfig")
    end

    local php_files = ctx.glob({ "**/*.php", "**/*.hh" })
    if composer_path == nil and hhconfig_path == nil and #php_files == 0 then
        error(
            "hhvm plugin: no composer.json, .hhconfig, or **/*.php found — "
                .. "add a PHP/Hack project or set project_root in configure()"
        )
    end

    local root = cfg.project_root or M.project_root(composer_path, hhconfig_path)
    local output_name = cfg.output_name or M.package_name(composer_path)
    local entry_points = cfg.entry_points

    if entry_points == nil then
        entry_points = M.resolve_entry_points(ctx, root)
    end

    if #entry_points == 0 then
        error("hhvm plugin: no PHP/Hack entry points found — add index.php or configure entry_points")
    end

    local build_dir = cfg.build_dir or "build/hhvm"
    local bin_dir = cfg.bin_dir or build_dir

    return {
        composer_json = composer_path,
        hhconfig = hhconfig_path,
        has_composer = composer_path ~= nil,
        has_hhconfig = hhconfig_path ~= nil,
        project_root = root,
        package_name = output_name,
        entry_points = entry_points,
        build_dir = build_dir,
        bin_dir = bin_dir,
        primary_output = build_dir .. "/.hhvm-checked",
        primary_source = entry_points[1],
    }
end

return M
