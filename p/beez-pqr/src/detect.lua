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
        or path:match("test%-that") ~= nil
        or path:match("testthat") ~= nil
end

function M.find_description(ctx)
    local files = ctx.glob({ "DESCRIPTION", "**/DESCRIPTION" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(description_path)
    if description_path == nil then
        return "."
    end
    return dirname(description_path)
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

function M.resolve_build_targets(ctx, root, description_path, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or M.package_name(description_path)
    local targets = {}
    local seen = {}

    if description_path ~= nil then
        targets[#targets + 1] = {
            source = description_path,
            name = package_name,
            output = nil,
            kind = "package",
        }
        return targets
    end

    local candidates = {
        prefix .. "main.R",
        prefix .. "R/main.R",
        prefix .. "src/main.R",
        prefix .. package_name .. ".R",
        prefix .. "R/" .. package_name .. ".R",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.R$") or package_name,
                    output = nil,
                    kind = "script",
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local r_files = ctx.glob({ prefix .. "R/*.R", prefix .. "*.R" })
        sort_shallow_first(r_files)
        for _, source in ipairs(r_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.R$") or package_name,
                    output = nil,
                    kind = "script",
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("pqr plugin: no DESCRIPTION or .R entry point found — add a package or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local description_path = cfg.description_path
    if description_path == nil then
        description_path = M.find_description(ctx)
    end

    local r_files = ctx.glob({ "**/*.R" })
    if description_path == nil and #r_files == 0 then
        error("pqr plugin: no DESCRIPTION or *.R files found — add an R project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(description_path)
    local output_name = cfg.output_name or M.package_name(description_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, description_path, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/pqr"
    local lib_dir = cfg.lib_dir or (bin_dir .. "/lib")

    for _, target in ipairs(targets) do
        if target.output == nil then
            if target.kind == "package" then
                target.output = lib_dir .. "/" .. (target.name or output_name)
            else
                target.output = bin_dir .. "/" .. (target.name or output_name) .. ".Rc"
            end
        end
    end

    return {
        description_path = description_path,
        has_package = description_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        lib_dir = lib_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
