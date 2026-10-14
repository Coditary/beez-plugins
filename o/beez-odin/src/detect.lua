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

function M.find_build_odin(ctx)
    local files = ctx.glob({ "build.odin", "**/build.odin" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(build_odin_path)
    if build_odin_path == nil then
        return "."
    end
    return dirname(build_odin_path)
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/tests/**/*.odin",
        prefix .. "/test/**/*.odin",
        prefix .. "/**/*_test.odin",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local build_odin_path = cfg.build_odin_path
    if build_odin_path == nil then
        build_odin_path = M.find_build_odin(ctx)
    end

    local odins = ctx.glob({ "**/*.odin" })
    if build_odin_path == nil and #odins == 0 then
        error("odin plugin: no build.odin or *.odin files found — add an Odin project or set build_odin_path in configure()")
    end

    local root = cfg.project_root or M.project_root(build_odin_path)
    local bin_dir = cfg.bin_dir or "build/odin/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        build_odin_path = build_odin_path,
        has_build_odin = build_odin_path ~= nil,
        project_root = root,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
