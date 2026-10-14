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

function M.find_mojoproject(ctx)
    local files = ctx.glob({ "mojoproject.toml", "**/mojoproject.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(mojoproject_path)
    if mojoproject_path == nil then
        return "."
    end
    return dirname(mojoproject_path)
end

function M.package_name(mojoproject_path)
    if mojoproject_path == nil then
        return "app"
    end

    local content = nil
    local ok, file = pcall(io.open, mojoproject_path, "r")
    if ok and file ~= nil then
        content = file:read("*a")
        file:close()
    end

    if content ~= nil then
        local name = content:match('\nname%s*=%s*["\']([^"\']+)["\']')
            or content:match('^name%s*=%s*["\']([^"\']+)["\']')
        if name ~= nil and name ~= "" then
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

local function source_name(source, fallback)
    local name = basename(source)
    name = name:match("^(.+)%.mojo$") or name:match("^(.+)%.🔥$") or name
    if name == nil or name == "" then
        return fallback
    end
    return name
end

function M.resolve_build_targets(ctx, root, mojoproject_path, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or M.package_name(mojoproject_path)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/main.mojo",
        prefix .. "src/main.🔥",
        prefix .. "main.mojo",
        prefix .. "main.🔥",
        prefix .. "src/" .. package_name .. ".mojo",
        prefix .. "src/" .. package_name .. ".🔥",
        prefix .. package_name .. ".mojo",
        prefix .. package_name .. ".🔥",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = source_name(source, package_name),
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
        local src_files = ctx.glob({ prefix .. "src/*.mojo", prefix .. "src/*.🔥" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/tests/") and not source:match("/test/") then
                targets[#targets + 1] = {
                    source = source,
                    name = source_name(source, package_name),
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.mojo", prefix .. "*.🔥" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            targets[#targets + 1] = {
                source = source,
                name = source_name(source, package_name),
                output = nil,
            }
            break
        end
    end

    if #targets == 0 then
        error("mojo plugin: no .mojo or .🔥 entry point found — add src/main.mojo or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local mojoproject_path = cfg.mojoproject_path
    if mojoproject_path == nil then
        mojoproject_path = M.find_mojoproject(ctx)
    end

    local sources = ctx.glob({ "**/*.mojo", "**/*.🔥" })
    if mojoproject_path == nil and #sources == 0 then
        error("mojo plugin: no mojoproject.toml or Mojo source files found — add a Mojo project or set mojoproject_path in configure()")
    end

    local root = cfg.project_root or M.project_root(mojoproject_path)
    local output_name = cfg.output_name or M.package_name(mojoproject_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, mojoproject_path, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/mojo/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    local include_paths = cfg.include_paths
    if include_paths == nil and root ~= "." and root ~= "" then
        include_paths = { root .. "/src" }
    elseif include_paths == nil then
        include_paths = { "src" }
    end

    return {
        mojoproject_path = mojoproject_path,
        has_mojoproject = mojoproject_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        include_paths = include_paths,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
