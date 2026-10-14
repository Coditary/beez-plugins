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

local function dirname(path)
    local dir = path:match("^(.*)/[^/]+$")
    if dir == nil or dir == "" then
        return "."
    end
    return dir
end

function M.resolve_doxyfile(ctx, root, cfg_doxyfile)
    if cfg_doxyfile ~= nil and cfg_doxyfile ~= "" then
        return cfg_doxyfile, dirname(cfg_doxyfile)
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local doxyfiles = ctx.glob({
        prefix .. "/Doxyfile",
        prefix .. "/**/Doxyfile",
    })

    sort_shallow_first(doxyfiles)

    if #doxyfiles > 0 then
        local doxyfile = doxyfiles[1]
        return doxyfile, dirname(doxyfile)
    end

    return nil, nil
end

function M.has_source_files(ctx)
    local source_files = ctx.glob({
        "**/*.c",
        "**/*.cpp",
        "**/*.h",
        "**/*.hpp",
        "**/*.go",
    })

    return #source_files > 0
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/tests/**/*.c",
        prefix .. "/tests/**/*.cpp",
        prefix .. "/tests/**/*.h",
        prefix .. "/tests/**/*.go",
        prefix .. "/test/**/*.c",
        prefix .. "/test/**/*.cpp",
        prefix .. "/test/**/*.h",
        prefix .. "/test/**/*.go",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local doxyfiles = ctx.glob({ "Doxyfile", "**/Doxyfile" })
    local has_sources = M.has_source_files(ctx)

    if #doxyfiles == 0 and not has_sources then
        error("doxygen plugin: no Doxyfile or source files (*.c, *.cpp, *.h, *.go) found — add a Doxygen project or set doxyfile in configure()")
    end

    local root = cfg.project_root or "."
    local doxyfile, project_dir = M.resolve_doxyfile(ctx, root, cfg.doxyfile)

    if project_dir == nil then
        project_dir = root
    end

    local bin_dir = cfg.bin_dir or "build/doxygen/html"
    local output_name = cfg.output_name or "index.html"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        doxyfile = doxyfile,
        project_dir = project_dir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
