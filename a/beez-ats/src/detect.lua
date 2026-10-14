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

function M.resolve_compile_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local patterns = {
        prefix .. "main.dats",
        prefix .. "src/main.dats",
        prefix .. "**/*.dats",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
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
        if #targets > 0 and pattern:match("%*%*") == nil then
            break
        end
    end

    if #targets == 0 then
        error("ats plugin: no .dats compile targets found — add ATS sources or set targets in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local dats_files = ctx.glob({ "**/*.dats" })
    local sats_files = ctx.glob({ "**/*.sats" })
    if #dats_files == 0 and #sats_files == 0 then
        error("ats plugin: no *.dats or *.sats files found — add ATS sources or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/ats"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
        primary_output = targets[1].output,
    }
end

return M
