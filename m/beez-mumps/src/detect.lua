local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
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
        or path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.[^%.]+$")
    return name or fallback or "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_compile_targets(ctx, root, output_name)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ "**/*.mps" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_path(source) and (source:match(".mps$")) then
            seen[source] = true
            targets[#targets + 1] = {
                source = source,
                name = M.entry_name(source, package_name),
                output = nil,
            }
        end
    end

    if #targets == 0 then
        error("mumps plugin: no entry point found — add source files or configure targets")
    end

    return targets
end

function M.resolve_all_targets(ctx, root)
    return M.resolve_compile_targets(ctx, root, "app")
end

function M.resolve(ctx, cfg)
    local files = ctx.glob({ "**/*.mps" })
    if #files == 0 then
        error("mumps plugin: no source files found — add files or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets or M.resolve_all_targets(ctx, root)
    local bin_dir = cfg.bin_dir or "build/mumps"
    local entry = M.resolve_compile_targets(ctx, root, output_name)

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = entry[1].source,
        entry_targets = entry,
    }
end

return M
