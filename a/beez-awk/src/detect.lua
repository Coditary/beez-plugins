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
        or path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
end

function M.project_root(source_path)
    if source_path == nil then
        return "."
    end
    return dirname(source_path)
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.awk$")
    return name or fallback or "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_compile_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.awk",
        prefix .. "src/main.awk",
        prefix .. package_name .. ".awk",
        prefix .. "src/" .. package_name .. ".awk",
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
        local src_files = ctx.glob({ prefix .. "src/*.awk" })
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
        local root_files = ctx.glob({ prefix .. "*.awk" })
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
        error("awk plugin: no .awk entry point found — add main.awk or configure targets")
    end

    return targets
end

function M.resolve_all_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.awk" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_path(source) then
            seen[source] = true
            targets[#targets + 1] = {
                source = source,
                name = M.entry_name(source, "app"),
                output = nil,
            }
        end
    end

    if #targets == 0 then
        error("awk plugin: no *.awk files found — add AWK sources or set targets in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local awk_files = ctx.glob({ "**/*.awk" })
    if #awk_files == 0 then
        error("awk plugin: no *.awk files found — add AWK sources or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_all_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/awk"

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
        entry_targets = M.resolve_compile_targets(ctx, root, output_name),
    }
end

return M
