local M = {}

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

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("_test%.nelua$") ~= nil
end

function M.has_project_config(ctx, root)
    local prefix = glob_prefix(root)
    local configs = ctx.glob({ prefix .. "project.nelua" })
    return #configs > 0, configs[1]
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.nelua",
        prefix .. "src/main.nelua",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.nelua" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not is_test_path(source) and not source:match("project%.nelua$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.nelua" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not is_test_path(source) and not source:match("project%.nelua$") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.nelua",
        prefix .. "test/**/*.nelua",
        prefix .. "**/*_test.nelua",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local nelua_files = ctx.glob({ "**/*.nelua" })
    local project_files = ctx.glob({ "project.nelua", "**/project.nelua" })

    if #nelua_files == 0 and #project_files == 0 then
        error("nelua plugin: no project.nelua or *.nelua files found — add Nelua sources or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local has_project, project_config = M.has_project_config(ctx, root)
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/nelua/bin"
    local gen_dir = cfg.gen_dir or "build/nelua/gen"
    local primary_output = bin_dir .. "/" .. output_name
    local primary_c_output = gen_dir .. "/" .. output_name .. ".c"
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        project_config = project_config,
        has_project = has_project,
        bin_dir = bin_dir,
        gen_dir = gen_dir,
        output_name = output_name,
        primary_output = primary_output,
        primary_c_output = primary_c_output,
        has_tests = has_tests,
    }
end

return M
