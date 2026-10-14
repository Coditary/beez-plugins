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
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(makefile_pl_path)
    if makefile_pl_path == nil then
        return "."
    end
    return dirname(makefile_pl_path)
end

function M.package_name(makefile_pl_path)
    if makefile_pl_path == nil then
        return "app"
    end

    local name = basename(dirname(makefile_pl_path))
    if name ~= "." and name ~= "" then
        return name
    end
    return "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "app.pl",
        prefix .. "main.pl",
        prefix .. "script.pl",
        prefix .. "bin/app.pl",
        prefix .. "bin/main.pl",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                local name = basename(source):match("^(.+)%.pl$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local pl_files = ctx.glob({ prefix .. "**/*.pl" })
        sort_shallow_first(pl_files)
        for _, source in ipairs(pl_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+)%.pl$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("perl-bc plugin: no .pl entry point found — add app.pl or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local makefile_pl_path = cfg.makefile_pl_path
    if makefile_pl_path == nil then
        makefile_pl_path = M.find_manifest(ctx, "Makefile.PL")
    end

    local pl_files = ctx.glob({ "**/*.pl" })
    if makefile_pl_path == nil and #pl_files == 0 then
        error("perl-bc plugin: no Makefile.PL or *.pl files found — add a Perl project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(makefile_pl_path)
    local output_name = cfg.output_name or M.package_name(makefile_pl_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/perl-bc"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name .. ".c"
        end
    end

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
    local test_dirs = ctx.glob({ "t", "t/**", root .. "/t", root .. "/t/**" })
    if #test_dirs > 0 then
        test_dir = "t"
        if root ~= "." and root ~= "" then
            test_dir = root .. "/t"
        end
    end

    return {
        makefile_pl_path = makefile_pl_path,
        has_makefile_pl = makefile_pl_path ~= nil,
        has_makefile = makefile_path ~= nil,
        has_test_dir = test_dir ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        test_dir = test_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
