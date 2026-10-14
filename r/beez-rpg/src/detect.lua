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
        or path:match("^tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
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

    local patterns = {
        prefix .. "**/*.rpgle",
        prefix .. "**/*.sqlrpgle",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
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
    end

    if #targets == 0 then
        error("rpg plugin: no .rpgle or .sqlrpgle source files found — add RPG sources or set project_root in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local rpgle_files = ctx.glob({ "**/*.rpgle" })
    local sqlrpgle_files = ctx.glob({ "**/*.sqlrpgle" })
    if #rpgle_files == 0 and #sqlrpgle_files == 0 then
        error("rpg plugin: no *.rpgle or *.sqlrpgle files found — add RPG sources or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/rpg"

    return {
        project_root = root,
        package_name = targets[1].name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
    }
end

return M
