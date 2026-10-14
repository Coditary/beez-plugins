local M = {}

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

function M.find_project_json(ctx)
    local files = ctx.glob({ "project.json", "**/project.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(project_json_path)
    if project_json_path == nil then
        return "."
    end
    return dirname(project_json_path)
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.c3",
        prefix .. "test/**/*.c3",
        prefix .. "**/*_test.c3",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local project_json_path = cfg.project_json_path
    if project_json_path == nil then
        project_json_path = M.find_project_json(ctx)
    end

    local c3_files = ctx.glob({ "**/*.c3" })
    if project_json_path == nil and #c3_files == 0 then
        error("c3 plugin: no project.json or *.c3 files found — add a C3 project or set project_json_path in configure()")
    end

    local root = cfg.project_root or M.project_root(project_json_path)
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/c3/bin"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_json_path = project_json_path,
        has_project_json = project_json_path ~= nil,
        project_root = root,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
