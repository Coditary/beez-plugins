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

local function find_first(ctx, patterns)
    local matches = ctx.glob(patterns)
    if #matches == 0 then
        return nil
    end

    sort_shallow_first(matches)
    return matches[1]
end

function M.find_info_rkt(ctx)
    return find_first(ctx, { "info.rkt", "**/info.rkt" })
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.is_test_path(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("-test%.rkt$") ~= nil
        or path:match("_test%.rkt$") ~= nil
        or path:match("^test/") ~= nil
        or path:match("^tests/") ~= nil
end

function M.find_modules(ctx, root)
    local prefix = glob_prefix(root)
    local modules = ctx.glob({
        prefix .. "**/*.rkt",
    })

    local filtered = {}
    for _, path in ipairs(modules) do
        if not M.is_test_path(path) and basename(path) ~= "info.rkt" then
            filtered[#filtered + 1] = path
        end
    end

    sort_shallow_first(filtered)
    return filtered
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.rkt",
        prefix .. package_name .. "/main.rkt",
        prefix .. "src/main.rkt",
        prefix .. package_name .. ".rkt",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not M.is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
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
        local modules = M.find_modules(ctx, root)
        for _, source in ipairs(modules) do
            local name = basename(source):match("^(.+)%.rkt$") or package_name
            targets[#targets + 1] = {
                source = source,
                name = name,
                output = nil,
            }
            break
        end
    end

    if #targets == 0 then
        error("racket plugin: no .rkt entry point found — add main.rkt or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local info_rkt = cfg.info_rkt
    if info_rkt == nil then
        info_rkt = M.find_info_rkt(ctx)
    end

    local rkt_files = ctx.glob({ "**/*.rkt" })
    if info_rkt == nil and #rkt_files == 0 then
        error("racket plugin: no info.rkt or **/*.rkt found — add a Racket project or set project_root in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        if info_rkt ~= nil then
            root = dirname(info_rkt)
        else
            root = "."
        end
    end

    local output_name = cfg.output_name or "app"
    local modules = cfg.modules
    if modules == nil then
        modules = M.find_modules(ctx, root)
    end

    local targets = cfg.targets
    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/racket/compiled"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.source .. ".zo"
        end
    end

    return {
        info_rkt = info_rkt,
        has_info = info_rkt ~= nil,
        project_root = root,
        package_name = output_name,
        modules = modules,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
