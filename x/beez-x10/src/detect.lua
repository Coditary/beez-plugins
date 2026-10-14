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
        or path:match("^tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
end

function M.find_x10_properties(ctx)
    local files = ctx.glob({ "X10.properties", "**/X10.properties" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(x10_properties_path)
    if x10_properties_path == nil then
        return "."
    end
    return dirname(x10_properties_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_compile_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.x10" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_path(source) then
            seen[source] = true
            local name = basename(source):match("^(.+)%.[^%.]+$") or basename(source)
            targets[#targets + 1] = {
                source = source,
                name = name,
                output = nil,
            }
        end
    end

    if #targets == 0 then
        error("x10 plugin: no .x10 source files found — add X10 sources or set project_root in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local x10_properties_path = cfg.x10_properties_path
    if x10_properties_path == nil then
        x10_properties_path = M.find_x10_properties(ctx)
    end

    local x10_files = ctx.glob({ "**/*.x10" })
    if x10_properties_path == nil and #x10_files == 0 then
        error("x10 plugin: no X10.properties or *.x10 files found — add an X10 project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(x10_properties_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/x10"

    return {
        x10_properties_path = x10_properties_path,
        has_x10_properties = x10_properties_path ~= nil,
        project_root = root,
        package_name = targets[1].name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
    }
end

return M
