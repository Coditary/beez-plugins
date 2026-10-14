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
    return path:match("%.jcl$") ~= nil
end

function M.project_root(source_path)
    if source_path == nil then
        return "."
    end
    return dirname(source_path)
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "job"
    end
    local name = basename(source_path):match("^(.+)%.[^%.]+$")
    return name or fallback or "job"
end

function M.resolve_entry_source(ctx, root)
    local prefix = ""
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local candidates = {
        prefix .. "main.jcl",
        prefix .. "job.jcl",
        prefix .. "app.jcl",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local matches = ctx.glob({ prefix .. "**/*.jcl" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if is_source_file(source) and not is_test_path(source) then
            return source
        end
    end

    return nil
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = ""
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local package_name = output_name or "job"
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.jcl" })
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

    if #targets == 0 then
        error("jcl plugin: no source files found — add *.jcl sources or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local jcl_files = ctx.glob({ "**/*.jcl" })

    if #jcl_files == 0 then
        error("jcl plugin: no *.jcl files found — add sources or set project_root in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        local entry = M.resolve_entry_source(ctx, ".")
        root = M.project_root(entry)
    end

    local output_name = cfg.output_name or "job"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/jcl/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name) .. ".jcl"
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
