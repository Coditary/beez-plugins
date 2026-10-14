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

function M.find_vmod(ctx)
    local files = ctx.glob({ "v.mod", "**/v.mod" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(vmod_path)
    if vmod_path == nil then
        return "."
    end
    return dirname(vmod_path)
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
        prefix .. "main.v",
        prefix .. "cmd/main/main.v",
        prefix .. "cmd/" .. package_name .. "/main.v",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
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
        local root_files = ctx.glob({ prefix .. "*.v" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not source:match("_test%.v$") then
                local name = basename(source):match("^(.+)%.v$") or package_name
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
        error("v plugin: no .v entry point found — add main.v or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local vmod_path = cfg.vmod_path
    if vmod_path == nil then
        vmod_path = M.find_vmod(ctx)
    end

    local vs = ctx.glob({ "**/*.v" })
    if vmod_path == nil and #vs == 0 then
        error("v plugin: no v.mod or *.v files found — add a V project or set vmod_path in configure()")
    end

    local root = cfg.project_root or M.project_root(vmod_path)
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/v/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        vmod_path = vmod_path,
        has_vmod = vmod_path ~= nil,
        project_root = root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
