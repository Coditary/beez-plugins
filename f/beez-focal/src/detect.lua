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

local function is_source_file(path)
    return path:match("%.fcl$") ~= nil or path:match("%.focal$") ~= nil
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
    local name = basename(source_path):match("^(.+)%.[^%.]+$")
    return name or fallback or "app"
end

function M.resolve_entry_source(ctx, root)
    local prefix = ""
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local candidates = {
        prefix .. "main.fcl",
        prefix .. "main.focal",
        prefix .. "app.fcl",
        prefix .. "app.focal",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local patterns = {
        prefix .. "**/*.fcl",
        prefix .. "**/*.focal",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        for _, source in ipairs(matches) do
            if is_source_file(source) and not is_test_path(source) then
                return source
            end
        end
    end

    return nil
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = ""
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local patterns = {
        prefix .. "**/*.fcl",
        prefix .. "**/*.focal",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        for _, source in ipairs(matches) do
            if not seen[source] and is_source_file(source) and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    output = nil,
                }
            end
        end
    end

    if #targets == 0 then
        error("focal plugin: no source files found — add *.fcl/*.focal sources or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local fcl_files = ctx.glob({ "**/*.fcl" })
    local focal_files = ctx.glob({ "**/*.focal" })

    if #fcl_files == 0 and #focal_files == 0 then
        error("focal plugin: no *.fcl or *.focal files found — add sources or set project_root in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        local entry = M.resolve_entry_source(ctx, ".")
        root = M.project_root(entry)
    end

    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/focal/bin"
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
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
