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

function M.find_moon_pkg(ctx)
    local files = ctx.glob({ "moon.pkg.json", "**/moon.pkg.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(moon_pkg_path)
    if moon_pkg_path == nil then
        return "."
    end
    return dirname(moon_pkg_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "**/*_test.mbt",
        prefix .. "test/**/*.mbt",
        prefix .. "tests/**/*.mbt",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local moon_pkg_path = cfg.moon_pkg_path
    if moon_pkg_path == nil then
        moon_pkg_path = M.find_moon_pkg(ctx)
    end

    local mbts = ctx.glob({ "**/*.mbt" })
    if moon_pkg_path == nil and #mbts == 0 then
        error("moonbit plugin: no moon.pkg.json or *.mbt files found — add a MoonBit project or set moon_pkg_path in configure()")
    end

    local root = cfg.project_root or M.project_root(moon_pkg_path)
    local bin_dir = cfg.bin_dir or "build/moonbit/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        moon_pkg_path = moon_pkg_path,
        has_moon_pkg = moon_pkg_path ~= nil,
        project_root = root,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
