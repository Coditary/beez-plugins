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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.project_root(first_source)
    if first_source ~= nil then
        return dirname(first_source)
    end
    return "."
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.golo",
        prefix .. "src/main.golo",
        prefix .. output_name .. ".golo",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = output_name,
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
        local golo_files = ctx.glob({ prefix .. "**/*.golo" })
        sort_shallow_first(golo_files)
        for _, source in ipairs(golo_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+)%.golo$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local source_files = ctx.glob({ "**/*.golo" })

    if #source_files == 0 then
        error("golo plugin: no **/*.golo files found — add a Golo project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(source_files[1])
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    if #targets == 0 then
        error("golo plugin: no Golo source files found — add **/*.golo or configure targets")
    end

    local bin_dir = cfg.bin_dir or "build/golo"
    local output_ext = cfg.output_ext
    if output_ext == nil then
        output_ext = "jar"
    end
    for _, target in ipairs(targets) do
        if target.output == nil then
            local base = target.name or output_name
            if output_ext == "" then
                target.output = bin_dir .. "/" .. base
            else
                target.output = bin_dir .. "/" .. base .. "." .. output_ext
            end
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
