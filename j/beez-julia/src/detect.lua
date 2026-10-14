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

function M.find_project_toml(ctx)
    local files = ctx.glob({ "Project.toml", "**/Project.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(project_toml_path)
    if project_toml_path == nil then
        return "."
    end
    return dirname(project_toml_path)
end

function M.package_name(project_toml_path)
    if project_toml_path == nil then
        return "app"
    end

    local root = M.project_root(project_toml_path)
    if root ~= "." and root ~= "" then
        local dir_name = basename(root)
        if dir_name ~= nil and dir_name ~= "" then
            return dir_name
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

function M.resolve_build_targets(ctx, root, project_toml_path, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or M.package_name(project_toml_path)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/" .. package_name .. ".jl",
        prefix .. "src/main.jl",
        prefix .. package_name .. ".jl",
        prefix .. "main.jl",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                local kind = "script"
                if project_toml_path ~= nil and source:match("/src/" .. package_name .. "%.jl$") then
                    kind = "package"
                end
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
                    output = nil,
                    kind = kind,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 and project_toml_path ~= nil then
        targets[#targets + 1] = {
            source = prefix .. "src/" .. package_name .. ".jl",
            name = package_name,
            output = nil,
            kind = "package",
        }
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.jl" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/test/") and not source:match("/tests/") then
                local name = basename(source):match("^(.+)%.jl$") or package_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                    kind = "script",
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.jl" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            local name = basename(source):match("^(.+)%.jl$") or package_name
            targets[#targets + 1] = {
                source = source,
                name = name,
                output = nil,
                kind = "script",
            }
            break
        end
    end

    if #targets == 0 then
        error("julia plugin: no .jl entry point found — add src/" .. package_name .. ".jl or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local project_toml_path = cfg.project_toml_path
    if project_toml_path == nil then
        project_toml_path = M.find_project_toml(ctx)
    end

    local jl_files = ctx.glob({ "**/*.jl" })
    if project_toml_path == nil and #jl_files == 0 then
        error("julia plugin: no Project.toml or *.jl files found — add a Julia project or set project_toml_path in configure()")
    end

    local root = cfg.project_root or M.project_root(project_toml_path)
    local output_name = cfg.output_name or M.package_name(project_toml_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, project_toml_path, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/julia/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name) .. ".compiled"
        end
    end

    return {
        project_toml_path = project_toml_path,
        has_project = project_toml_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
