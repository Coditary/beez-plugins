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
        or path:match("%.spec%.") ~= nil
        or path:match("%.test%.") ~= nil
end

function M.find_project_json(ctx)
    local files = ctx.glob({ "default.project.json", "**/default.project.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(project_json_path, source_path)
    if project_json_path ~= nil then
        return dirname(project_json_path)
    end

    if source_path == nil then
        return "."
    end

    return dirname(source_path)
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.luau$")
        or basename(source_path):match("^(.+)%.lua$")
    return name or fallback or "app"
end

function M.collect_sources(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local patterns = {
        prefix .. "**/*.luau",
        prefix .. "**/*.lua",
    }

    local sources = {}
    local seen = {}

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                sources[#sources + 1] = source
            end
        end
    end

    sort_shallow_first(sources)
    return sources
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/init.luau",
        prefix .. "init.luau",
        prefix .. "main.luau",
        prefix .. "src/main.luau",
        prefix .. package_name .. ".luau",
        prefix .. "src/" .. package_name .. ".luau",
        prefix .. "main.lua",
        prefix .. "src/main.lua",
        prefix .. package_name .. ".lua",
        prefix .. "src/" .. package_name .. ".lua",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
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
        local src_files = ctx.glob({ prefix .. "src/*.luau", prefix .. "src/*.lua" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.luau", prefix .. "*.lua" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("luau plugin: no .luau/.lua entry point found — add init.luau, main.luau, or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local project_json_path = cfg.project_json_path
    if project_json_path == nil then
        project_json_path = M.find_project_json(ctx)
    end

    local luau_files = ctx.glob({ "**/*.luau", "**/*.lua" })
    if project_json_path == nil and #luau_files == 0 then
        error("luau plugin: no *.luau/*.lua or default.project.json found — add Luau sources or set targets in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        root = M.project_root(project_json_path, luau_files[1])
    end

    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.collect_sources(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/luau"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name) .. ".luauc"
        end
    end

    return {
        project_json_path = project_json_path,
        has_project_json = project_json_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        sources = sources,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
