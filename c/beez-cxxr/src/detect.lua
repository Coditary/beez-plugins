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
        or path:match("/test%-") ~= nil
        or path:match("^test%-") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(description_path)
    if description_path ~= nil then
        return dirname(description_path)
    end
    return "."
end

function M.package_name(description_path)
    if description_path ~= nil then
        local name = basename(dirname(description_path))
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
        prefix .. "R/" .. package_name .. ".R",
        prefix .. "R/main.R",
        prefix .. "R/app.R",
        prefix .. "R/init.R",
        prefix .. "R/zzz.R",
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
        local r_files = ctx.glob({ prefix .. "R/*.R", prefix .. "R/**/*.R" })
        sort_shallow_first(r_files)
        for _, source in ipairs(r_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.R$") or package_name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.R" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.R$") or package_name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("cxxr plugin: no .R entry point found — add R/*.R or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local description_path = cfg.description_path
    if description_path == nil then
        description_path = M.find_manifest(ctx, "DESCRIPTION")
    end

    local r_files = ctx.glob({ "**/*.R" })
    if description_path == nil and #r_files == 0 then
        error("cxxr plugin: no DESCRIPTION or *.R files found — add an R package or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(description_path)
    local output_name = cfg.output_name or M.package_name(description_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/cxxr"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name .. ".tar.gz"
        end
    end

    return {
        description_path = description_path,
        has_description = description_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
