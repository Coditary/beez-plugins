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
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.io",
        prefix .. "src/main.io",
        prefix .. package_name .. ".io",
        prefix .. "src/" .. package_name .. ".io",
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
        local patterns = { prefix .. "src/*.io", prefix .. "*.io" }
        for _, pattern in ipairs(patterns) do
            local matches = ctx.glob({ pattern })
            sort_shallow_first(matches)
            for _, source in ipairs(matches) do
                if not is_test_path(source) then
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
    end

    if #targets == 0 then
        error("io plugin: no .io entry point found — add main.io or configure targets")
    end

    return targets
end

function M.resolve_all_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.io" })
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
        error("io plugin: no *.io files found — add Io sources or set targets in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local io_files = ctx.glob({ "**/*.io" })
    if #io_files == 0 then
        error("io plugin: no *.io files found — add Io sources or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_all_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/io"

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = M.resolve_compile_targets(ctx, root, output_name)[1].source,
        entry_targets = M.resolve_compile_targets(ctx, root, output_name),
    }
end

return M
