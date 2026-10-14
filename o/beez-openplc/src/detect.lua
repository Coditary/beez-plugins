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
    return path:match("%.st$") ~= nil or path:match("%.plc$") ~= nil
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
        prefix .. "main.st",
        prefix .. "main.plc",
        prefix .. "app.st",
        prefix .. "program.st",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local patterns = {
        prefix .. "**/*.st",
        prefix .. "**/*.plc",
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
        prefix .. "**/*.st",
        prefix .. "**/*.plc",
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
                    c_output = nil,
                }
            end
        end
    end

    if #targets == 0 then
        error("openplc plugin: no source files found — add *.st/*.plc sources or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local st_files = ctx.glob({ "**/*.st" })
    local plc_files = ctx.glob({ "**/*.plc" })

    if #st_files == 0 and #plc_files == 0 then
        error("openplc plugin: no *.st or *.plc files found — add sources or set project_root in configure()")
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

    local bin_dir = cfg.bin_dir or "build/openplc/bin"
    local gen_dir = cfg.gen_dir or "build/openplc/gen"
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
