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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(project_janet_path)
    if project_janet_path ~= nil then
        return dirname(project_janet_path)
    end
    return "."
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.janet",
        prefix .. "src/main.janet",
        prefix .. "cli.janet",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.janet" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if source ~= prefix .. "project.janet" and not source:match("_test%.janet$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.janet" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("project%.janet$")
            and not source:match("_test%.janet$")
            and not source:match("/tests/")
            and not source:match("/test/") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.janet",
        prefix .. "tests/**/*.janet",
        prefix .. "**/*_test.janet",
    })

    return #test_files > 0 or M.find_manifest(ctx, prefix .. "project.janet") ~= nil
end

function M.resolve(ctx, cfg)
    local project_janet_path = cfg.project_janet_path
    if project_janet_path == nil then
        project_janet_path = M.find_manifest(ctx, "project.janet")
    end

    local janet_files = ctx.glob({ "**/*.janet" })
    if project_janet_path == nil and #janet_files == 0 then
        error("janet plugin: no project.janet or *.janet files found — add a Janet project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(project_janet_path)
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    if entry_source == nil and project_janet_path == nil then
        error("janet plugin: no .janet entry point found — add main.janet or configure entry_source")
    end

    local bin_dir = cfg.bin_dir or "build/janet/bin"
    local primary_output = bin_dir .. "/" .. output_name

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_janet_path = project_janet_path,
        has_project_janet = project_janet_path ~= nil,
        project_root = root,
        entry_source = entry_source,
        output_name = output_name,
        bin_dir = bin_dir,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
