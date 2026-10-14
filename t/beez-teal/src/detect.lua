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
        or path:match("_test%.tl$") ~= nil
end

function M.has_tlconfig(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local configs = ctx.glob({ prefix .. "tlconfig.lua" })
    return #configs > 0, configs[1]
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.tl$")
    return name or fallback or "app"
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
        prefix .. "main.tl",
        prefix .. "src/main.tl",
        prefix .. package_name .. ".tl",
        prefix .. "src/" .. package_name .. ".tl",
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
        local tl_files = ctx.glob({ prefix .. "*.tl", prefix .. "src/*.tl" })
        sort_shallow_first(tl_files)
        for _, source in ipairs(tl_files) do
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
        error("teal plugin: no .tl entry point found — add main.tl or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local tl_files = ctx.glob({ "**/*.tl" })
    local tlconfig_files = ctx.glob({ "tlconfig.lua", "**/tlconfig.lua" })

    if #tl_files == 0 and #tlconfig_files == 0 then
        error("teal plugin: no tlconfig.lua or *.tl files found — add Teal sources or set targets in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local has_tlconfig, tlconfig_path = M.has_tlconfig(ctx, root)
    local targets = cfg.targets

    if targets == nil and not has_tlconfig then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/teal"
    if targets ~= nil then
        for _, target in ipairs(targets) do
            if target.output == nil then
                target.output = bin_dir .. "/" .. (target.name or output_name) .. ".lua"
            end
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        has_tlconfig = has_tlconfig,
        tlconfig_path = tlconfig_path,
        primary_output = targets ~= nil and targets[1].output or bin_dir .. "/.teal-build",
        primary_source = targets ~= nil and targets[1].source or nil,
    }
end

return M
