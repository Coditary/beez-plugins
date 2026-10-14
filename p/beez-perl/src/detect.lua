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
    return path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("/xt/") ~= nil
        or path:match("^xt/") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(cpanfile_path, makefile_pl_path)
    if cpanfile_path ~= nil then
        return dirname(cpanfile_path)
    end
    if makefile_pl_path ~= nil then
        return dirname(makefile_pl_path)
    end
    return "."
end

function M.package_name(cpanfile_path, makefile_pl_path)
    if cpanfile_path ~= nil then
        local name = basename(dirname(cpanfile_path))
        if name ~= "." and name ~= "" then
            return name
        end
    end
    if makefile_pl_path ~= nil then
        local name = basename(dirname(makefile_pl_path))
        if name ~= "." and name ~= "" then
            return name
        end
    end
    return "app"
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
        prefix .. "**/*.pl",
        prefix .. "**/*.pm",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                local name = basename(source):match("^(.+)%.[^%.]+$") or basename(source)
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
            end
        end
    end

    if #targets == 0 then
        error("perl plugin: no .pl or .pm source files found — add Perl sources or set project_root in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local cpanfile_path = cfg.cpanfile_path
    if cpanfile_path == nil then
        cpanfile_path = M.find_manifest(ctx, "cpanfile")
    end

    local makefile_pl_path = cfg.makefile_pl_path
    if makefile_pl_path == nil then
        makefile_pl_path = M.find_manifest(ctx, "Makefile.PL")
    end

    local pl_files = ctx.glob({ "**/*.pl" })
    local pm_files = ctx.glob({ "**/*.pm" })
    if cpanfile_path == nil and makefile_pl_path == nil and #pl_files == 0 and #pm_files == 0 then
        error("perl plugin: no cpanfile, Makefile.PL, or *.pl/*.pm files found — add a Perl project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(cpanfile_path, makefile_pl_path)
    local output_name = cfg.output_name or M.package_name(cpanfile_path, makefile_pl_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/perl"
    local makefile_path = nil
    if root == "." or root == "" then
        makefile_path = M.find_manifest(ctx, "Makefile")
    else
        local makefiles = ctx.glob({ root .. "/Makefile" })
        if #makefiles > 0 then
            makefile_path = makefiles[1]
        end
    end

    local test_dir = nil
    local test_dirs = ctx.glob({ root .. "/t", "t", root .. "/t/**" })
    if #test_dirs > 0 then
        test_dir = "t"
        if root ~= "." and root ~= "" then
            test_dir = root .. "/t"
        end
    end

    return {
        cpanfile_path = cpanfile_path,
        makefile_pl_path = makefile_pl_path,
        has_cpanfile = cpanfile_path ~= nil,
        has_makefile_pl = makefile_pl_path ~= nil,
        has_makefile = makefile_path ~= nil,
        has_test_dir = test_dir ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        test_dir = test_dir,
        primary_source = targets[1].source,
    }
end

return M
