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
        or path:match("Tests%.php$") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(composer_path)
    if composer_path ~= nil then
        return dirname(composer_path)
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

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "public/index.php",
        prefix .. "index.php",
        prefix .. "bin/" .. package_name,
        prefix .. "bin/console",
        prefix .. "src/" .. package_name .. ".php",
        prefix .. package_name .. ".php",
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
        local src_files = ctx.glob({ prefix .. "src/**/*.php", prefix .. "src/*.php" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.php$") or package_name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.php" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.php$") or package_name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("php plugin: no .php entry point found — add index.php or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local composer_path = cfg.composer_path
    if composer_path == nil then
        composer_path = M.find_manifest(ctx, "composer.json")
    end

    local php_files = ctx.glob({ "**/*.php" })
    if composer_path == nil and #php_files == 0 then
        error("php plugin: no composer.json or *.php files found — add a PHP project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(composer_path)
    local output_name = cfg.output_name or M.package_name(composer_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/php"
    for _, target in ipairs(targets) do
        if target.output == nil then
            local source_base = target.source:match("^(.+)%.php$") or target.source
            target.output = bin_dir .. "/" .. source_base .. ".opcache"
        end
    end

    return {
        composer_path = composer_path,
        has_composer = composer_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
