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

function M.find_package_toml(ctx)
    local files = ctx.glob({ "package.toml", "**/package.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(manifest_path)
    if manifest_path == nil then
        return "."
    end
    return dirname(manifest_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.kk",
        prefix .. "src/main.kk",
        prefix .. "lib/main.kk",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    local sources = ctx.glob({ prefix .. "**/*.kk" })
    sort_shallow_first(sources)
    for _, source in ipairs(sources) do
        if not source:match("_test%.kk$") and not source:match("/test/") then
            return source
        end
    end

    if #sources > 0 then
        return sources[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.kk",
        prefix .. "tests/**/*.kk",
        prefix .. "**/*_test.kk",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local package_toml = cfg.package_toml
    if package_toml == nil then
        package_toml = M.find_package_toml(ctx)
    end

    local sources = ctx.glob({ "**/*.kk" })
    if package_toml == nil and #sources == 0 then
        error("koka plugin: no package.toml or *.kk files found — add a Koka project or set package_toml in configure()")
    end

    local root = cfg.project_root or M.project_root(package_toml)
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    if entry_source == nil and package_toml == nil then
        error("koka plugin: no Koka entry point found — add main.kk or configure entry_source")
    end

    local bin_dir = cfg.bin_dir or "build/koka/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        package_toml = package_toml,
        has_package_toml = package_toml ~= nil,
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
