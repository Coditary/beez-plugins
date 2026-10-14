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

function M.find_shard_yml(ctx)
    local files = ctx.glob({ "shard.yml", "**/shard.yml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(shard_path)
    if shard_path == nil then
        return "."
    end
    return dirname(shard_path)
end

function M.package_name(shard_path, root)
    if shard_path == nil then
        return "app"
    end

    if root ~= "." and root ~= "" then
        local name = basename(root)
        if name ~= "" then
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

function M.resolve_build_targets(ctx, root, shard_path, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or M.package_name(shard_path, root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/" .. package_name .. ".cr",
        prefix .. "src/main.cr",
        prefix .. package_name .. ".cr",
        prefix .. "main.cr",
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
        local src_files = ctx.glob({ prefix .. "src/*.cr" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/spec/") and not source:match("_spec%.cr$") then
                local name = basename(source):match("^(.+)%.cr$") or package_name
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
        local root_files = ctx.glob({ prefix .. "*.cr" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not source:match("_spec%.cr$") then
                local name = basename(source):match("^(.+)%.cr$") or package_name
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
        error("crystal plugin: no .cr entry point found — add src/main.cr or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local shard_path = cfg.shard_path
    if shard_path == nil then
        shard_path = M.find_shard_yml(ctx)
    end

    local crs = ctx.glob({ "**/*.cr" })
    if shard_path == nil and #crs == 0 then
        error("crystal plugin: no shard.yml or *.cr files found — add a Crystal project or set shard_path in configure()")
    end

    local root = cfg.project_root or M.project_root(shard_path)
    local output_name = cfg.output_name or M.package_name(shard_path, root)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, shard_path, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/crystal/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        shard_path = shard_path,
        has_shard = shard_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
