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

function M.find_carp_toml(ctx)
    local files = ctx.glob({ "Carp.toml", "**/Carp.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(carp_toml_path)
    if carp_toml_path == nil then
        return "."
    end
    return dirname(carp_toml_path)
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
        prefix .. "test/**/*.carp",
        prefix .. "tests/**/*.carp",
        prefix .. "**/*_test.carp",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local carp_toml_path = cfg.carp_toml_path
    if carp_toml_path == nil then
        carp_toml_path = M.find_carp_toml(ctx)
    end

    local carps = ctx.glob({ "**/*.carp" })
    if carp_toml_path == nil and #carps == 0 then
        error("carp plugin: no Carp.toml or *.carp files found — add a Carp project or set carp_toml_path in configure()")
    end

    local root = cfg.project_root or M.project_root(carp_toml_path)
    local bin_dir = cfg.bin_dir or "build/carp/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        carp_toml_path = carp_toml_path,
        has_carp_toml = carp_toml_path ~= nil,
        project_root = root,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
