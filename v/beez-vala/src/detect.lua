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

function M.find_meson_build(ctx)
    local files = ctx.glob({ "meson.build", "**/meson.build" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(meson_build_path)
    if meson_build_path == nil then
        return "."
    end
    return dirname(meson_build_path)
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

    local matches = ctx.glob({ prefix .. "**/*.vala" })
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
        error("vala plugin: no .vala source files found — add Vala sources or set project_root in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local meson_build_path = cfg.meson_build_path
    if meson_build_path == nil then
        meson_build_path = M.find_meson_build(ctx)
    end

    local vala_files = ctx.glob({ "**/*.vala" })
    if meson_build_path == nil and #vala_files == 0 then
        error("vala plugin: no meson.build or *.vala files found — add a Vala project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(meson_build_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/vala"

    return {
        meson_build_path = meson_build_path,
        has_meson_build = meson_build_path ~= nil,
        project_root = root,
        package_name = targets[1].name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
    }
end

return M
