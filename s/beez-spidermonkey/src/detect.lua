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
    return path:match("/tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("_test%.js$") ~= nil
        or path:match("%.test%.js$") ~= nil
        or path:match("%.spec%.js$") ~= nil
end

local function is_config_path(path)
    return path:match("%.config%.js$") ~= nil
        or path:match("eslint%.") ~= nil
        or path:match("webpack%.") ~= nil
        or path:match("rollup%.") ~= nil
        or path:match("jest%.") ~= nil
end

function M.project_root(source_path)
    if source_path == nil then
        return "."
    end
    return dirname(source_path)
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.js$")
    return name or fallback or "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "src/index.js",
        prefix .. "src/main.js",
        prefix .. "index.js",
        prefix .. "main.js",
        prefix .. package_name .. ".js",
        prefix .. "src/" .. package_name .. ".js",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) and not is_config_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
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
        local src_files = ctx.glob({ prefix .. "src/*.js" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) and not is_config_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.js" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) and not is_config_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("spidermonkey plugin: no .js entry point found — add index.js, main.js, or configure targets")
    end

    return targets
end

function M.resolve_test_targets(ctx, root)
    local prefix = glob_prefix(root)
    local patterns = {
        prefix .. "test/**/*.js",
        prefix .. "tests/**/*.js",
        prefix .. "**/*_test.js",
        prefix .. "**/*.test.js",
        prefix .. "**/*.spec.js",
    }

    local files = ctx.glob(patterns)
    sort_shallow_first(files)
    return files
end

function M.resolve(ctx, cfg)
    local js_files = ctx.glob({ "**/*.js" })
    if #js_files == 0 then
        error("spidermonkey plugin: no *.js files found — add JavaScript sources or set targets in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/spidermonkey"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name) .. ".js"
        end
        if target.stamp == nil then
            target.stamp = bin_dir .. "/." .. (target.name or output_name) .. "-validated"
        end
    end

    local test_targets = cfg.test_targets
    if test_targets == nil then
        test_targets = M.resolve_test_targets(ctx, root)
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        test_targets = test_targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        primary_stamp = targets[1].stamp,
    }
end

return M
