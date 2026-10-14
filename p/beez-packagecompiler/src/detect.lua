local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function depth(path)
    return select(2, path:gsub("/", ""))
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = depth(a)
        local depth_b = depth(b)
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

function M.parse_project_name(project_toml_path)
    local ok, file = pcall(io.open, project_toml_path, "r")
    if not ok or file == nil then
        return nil
    end

    local content = file:read("*a")
    file:close()

    if content == nil then
        return nil
    end

    local name = content:match('name%s*=%s*"([^"]+)"')
    if name == nil then
        name = content:match("name%s*=%s*'([^']+)'")
    end

    return name
end

function M.find_project_toml(ctx)
    local manifests = ctx.glob({ "Project.toml", "**/Project.toml" })
    if #manifests == 0 then
        return nil
    end

    sort_shallow_first(manifests)
    return manifests[1]
end

function M.resolve_entry_script(ctx, project_root, project_name, configured_entry)
    if configured_entry ~= nil and configured_entry ~= "" then
        return configured_entry
    end

    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    if project_name ~= nil and project_name ~= "" then
        local named = ctx.glob({ prefix .. "src/" .. project_name .. ".jl" })
        if #named > 0 then
            sort_shallow_first(named)
            return named[1]
        end
    end

    local src_files = ctx.glob({ prefix .. "src/*.jl", prefix .. "src/**/*.jl" })
    if #src_files > 0 then
        sort_shallow_first(src_files)
        return src_files[1]
    end

    local root_main = ctx.glob({ prefix .. "main.jl" })
    if #root_main > 0 then
        return root_main[1]
    end

    return nil
end

function M.resolve_module_name(project_name, entry_script)
    if project_name ~= nil and project_name ~= "" then
        return project_name
    end

    if entry_script == nil then
        return "app"
    end

    local stem = basename(entry_script):gsub("%.jl$", "")
    if stem == "" then
        return "app"
    end

    return stem
end

function M.relative_path(path, project_root)
    if project_root == "." or project_root == "" then
        return path
    end

    local prefix = project_root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return path
end

function M.resolve(ctx, cfg)
    local project_toml = cfg.project_toml or M.find_project_toml(ctx)
    if project_toml == nil then
        error(
            "packagecompiler plugin: no Project.toml found — "
                .. "add a Julia project or set project_toml in configure()"
        )
    end

    local project_root = cfg.project_root or dirname(project_toml)
    local project_name = cfg.project_name or M.parse_project_name(project_toml)
    local entry_script = M.resolve_entry_script(ctx, project_root, project_name, cfg.entry_script)

    if entry_script == nil then
        error(
            "packagecompiler plugin: no Julia entry script found — "
                .. "add src/<Package>.jl or set entry_script in configure()"
        )
    end

    local module_name = M.resolve_module_name(project_name, entry_script)
    local output_name = cfg.output_name or module_name
    local bin_dir = cfg.bin_dir or "build/packagecompiler/bin"
    local app_dir = cfg.app_dir or "build/packagecompiler"
    local sysimage_basename = cfg.sysimage_basename or "sysimage"

    return {
        project_toml = project_toml,
        project_root = project_root,
        project_name = project_name,
        entry_script = entry_script,
        entry_script_rel = M.relative_path(entry_script, project_root),
        module_name = module_name,
        bin_dir = bin_dir,
        app_dir = app_dir,
        output_name = output_name,
        primary_output = bin_dir .. "/" .. output_name,
        sysimage_basename = sysimage_basename,
    }
end

return M
