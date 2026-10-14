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

function M.find_build_jai(ctx)
    local files = ctx.glob({ "build.jai", "**/build.jai" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(build_jai_path)
    if build_jai_path == nil then
        return "."
    end
    return dirname(build_jai_path)
end

function M.resolve_entry_source(ctx, root, build_jai_path)
    if build_jai_path ~= nil then
        return build_jai_path
    end

    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.jai",
        prefix .. "first.jai",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.jai" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("_test%.jai$") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.jai",
        prefix .. "test/**/*.jai",
        prefix .. "**/*_test.jai",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local build_jai_path = cfg.build_jai_path
    if build_jai_path == nil then
        build_jai_path = M.find_build_jai(ctx)
    end

    local jai_files = ctx.glob({ "**/*.jai" })
    if build_jai_path == nil and #jai_files == 0 then
        error("jai plugin: no build.jai or *.jai files found — add a Jai project or set build_jai_path in configure()")
    end

    local root = cfg.project_root or M.project_root(build_jai_path)
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root, build_jai_path)
    end

    if entry_source == nil then
        error("jai plugin: no build.jai or entry .jai file found — add build.jai or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/jai/bin"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        build_jai_path = build_jai_path,
        has_build_jai = build_jai_path ~= nil,
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
