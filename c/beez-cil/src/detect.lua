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
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.il$")
    return name or fallback or "app"
end

function M.resolve_build_targets(ctx, root, output_name, output_kind)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local package_name = output_name or "app"
    local extension = output_kind == "dll" and ".dll" or ".exe"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.il",
        prefix .. "src/main.il",
        prefix .. "Main.il",
        prefix .. "src/Main.il",
        prefix .. package_name .. ".il",
        prefix .. "src/" .. package_name .. ".il",
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
                    output_kind = output_kind,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.il", prefix .. "**/*.il" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    output = nil,
                    output_kind = output_kind,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("cil plugin: no .il entry point found — add main.il or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local il_files = ctx.glob({ "**/*.il" })
    if #il_files == 0 then
        error("cil plugin: no **/*.il files found — add CIL assembly sources")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local output_kind = cfg.output_kind or "exe"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name, output_kind)
    end

    local bin_dir = cfg.bin_dir or "build/cil/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            local kind = target.output_kind or output_kind
            local extension = kind == "dll" and ".dll" or ".exe"
            target.output = bin_dir .. "/" .. (target.name or output_name) .. extension
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        output_kind = output_kind,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
