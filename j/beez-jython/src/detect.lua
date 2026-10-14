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
        or path:match("/test_[^/]+%.py$") ~= nil
        or path:match("^test_[^/]+%.py$") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(jython_path, setup_path, requirements_path)
    if jython_path ~= nil then
        return dirname(jython_path)
    end
    if setup_path ~= nil then
        return dirname(setup_path)
    end
    if requirements_path ~= nil then
        return dirname(requirements_path)
    end
    return "."
end

function M.package_name(jython_path, setup_path)
    if jython_path ~= nil then
        local name = basename(dirname(jython_path))
        if name ~= "." and name ~= "" then
            return name
        end
    end
    if setup_path ~= nil then
        local name = basename(dirname(setup_path))
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

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.py",
        prefix .. "src/main.py",
        prefix .. "src/" .. package_name .. "/__main__.py",
        prefix .. package_name .. "/__main__.py",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
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
        local src_files = ctx.glob({ prefix .. "src/**/*.py", prefix .. "src/*.py" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.py$") or package_name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.py" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.py$") or package_name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("jython plugin: no .py entry point found — add main.py or configure targets")
    end

    return targets
end

function M.resolve_all_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.py" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_path(source) then
            seen[source] = true
            targets[#targets + 1] = {
                source = source,
                name = basename(source):match("^(.+)%.py$") or "app",
                output = nil,
            }
        end
    end

    if #targets == 0 then
        error("jython plugin: no *.py files found — add Jython sources or set targets in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local jython_path = cfg.jython_path
    if jython_path == nil then
        jython_path = M.find_manifest(ctx, "jython")
    end

    local setup_path = cfg.setup_path
    if setup_path == nil then
        setup_path = M.find_manifest(ctx, "setup.py")
    end

    local requirements_path = cfg.requirements_path
    if requirements_path == nil then
        requirements_path = M.find_manifest(ctx, "requirements.txt")
    end

    local py_files = ctx.glob({ "**/*.py" })
    if jython_path == nil and setup_path == nil and requirements_path == nil and #py_files == 0 then
        error("jython plugin: no jython marker, setup.py, requirements.txt, or *.py files found — add a Jython project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(jython_path, setup_path, requirements_path)
    local output_name = cfg.output_name or M.package_name(jython_path, setup_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_all_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/jython"

    return {
        jython_path = jython_path,
        setup_path = setup_path,
        requirements_path = requirements_path,
        has_jython_marker = jython_path ~= nil,
        has_setup = setup_path ~= nil,
        has_requirements = requirements_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = M.resolve_build_targets(ctx, root, output_name)[1].source,
        entry_targets = M.resolve_build_targets(ctx, root, output_name),
    }
end

return M
