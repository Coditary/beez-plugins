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

function M.project_root(_manifest_path)
    return "."
end

function M.package_name(_manifest_path, source_path)
    if source_path ~= nil then
        local name = basename(source_path):match("^(.+)%.alg$")
        if name ~= nil then
            return name
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

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.alg",
        prefix .. "src/main.alg",
        prefix .. package_name .. ".alg",
        prefix .. "src/" .. package_name .. ".alg",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
                    output = nil,
                    c_output = nil,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ "**/*.alg" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+)%.alg$") or package_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                    c_output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("marst plugin: no .alg entry point found — add main.alg or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local sources = ctx.glob({ "**/*.alg" })
    if #sources == 0 then
        error("marst plugin: no source files found — add **/*.alg sources or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(nil)
    local output_name = cfg.output_name or M.package_name(nil, sources[1])
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/marst/bin"
    local gen_dir = cfg.gen_dir or "build/marst/gen"
    for _, target in ipairs(targets) do
        if target.c_output == nil then
            target.c_output = gen_dir .. "/" .. (target.name or output_name) .. ".c"
        end
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        gen_dir = gen_dir,
        primary_output = targets[1].output,
        primary_c_output = targets[1].c_output,
        primary_source = targets[1].source,
    }
end

return M
