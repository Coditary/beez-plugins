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
        or path:match("/__tests__/") ~= nil
        or path:match("_test%.gd$") ~= nil
end

function M.find_project_godot(ctx)
    local files = ctx.glob({ "project.godot", "**/project.godot" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(project_godot_path, primary_source)
    if project_godot_path ~= nil then
        return dirname(project_godot_path)
    end
    if primary_source ~= nil then
        return dirname(primary_source)
    end
    return "."
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "main"
    end

    local name = basename(source_path):match("^(.+)%.[^%.]+$")
    return name or fallback or "main"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_compile_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "main"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.gd",
        prefix .. "Main.gd",
        prefix .. "src/main.gd",
        prefix .. package_name .. ".gd",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local patterns = { prefix .. "src/*.gd", prefix .. "*.gd" }
        for _, pattern in ipairs(patterns) do
            local matches = ctx.glob({ pattern })
            sort_shallow_first(matches)
            for _, source in ipairs(matches) do
                if not is_test_path(source) then
                    targets[#targets + 1] = {
                        source = source,
                        name = M.entry_name(source, package_name),
                    }
                    break
                end
            end
            if #targets > 0 then
                break
            end
        end
    end

    if #targets == 0 then
        error("godot plugin: no .gd entry point found — add main.gd or configure targets")
    end

    return targets
end

function M.resolve_all_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.gd" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_path(source) then
            seen[source] = true
            targets[#targets + 1] = {
                source = source,
                name = M.entry_name(source, "app"),
            }
        end
    end

    if #targets == 0 then
        error("godot plugin: no *.gd files found — add Godot files or set targets in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local gd_files = ctx.glob({ "**/*.gd" })
    local project_godot_path = cfg.project_godot_path
    if project_godot_path == nil then
        project_godot_path = M.find_project_godot(ctx)
    end

    if #gd_files == 0 and project_godot_path == nil then
        error("godot plugin: no *.gd or project.godot found — add a Godot project or set project_godot_path in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        root = M.project_root(project_godot_path, gd_files[1])
    end

    local output_name = cfg.output_name or "main"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_all_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/godot"
    local entry_targets = M.resolve_compile_targets(ctx, root, output_name)

    return {
        project_godot_path = project_godot_path,
        has_project_godot = project_godot_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = entry_targets[1].source,
        entry_targets = entry_targets,
    }
end

return M
