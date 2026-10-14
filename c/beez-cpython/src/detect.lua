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

function M.project_root(pyproject_path, setup_path, requirements_path)
    if pyproject_path ~= nil then
        return dirname(pyproject_path)
    end
    if setup_path ~= nil then
        return dirname(setup_path)
    end
    if requirements_path ~= nil then
        return dirname(requirements_path)
    end
    return "."
end

function M.package_name(pyproject_path, setup_path)
    if pyproject_path ~= nil then
        local name = basename(dirname(pyproject_path))
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
        prefix .. "src/" .. package_name .. "/__init__.py",
        prefix .. package_name .. "/__init__.py",
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
        error("cpython plugin: no .py entry point found — add main.py or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local pyproject_path = cfg.pyproject_path
    if pyproject_path == nil then
        pyproject_path = M.find_manifest(ctx, "pyproject.toml")
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
    if pyproject_path == nil and setup_path == nil and requirements_path == nil and #py_files == 0 then
        error("cpython plugin: no pyproject.toml, setup.py, requirements.txt, or *.py files found — add a Python project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(pyproject_path, setup_path, requirements_path)
    local output_name = cfg.output_name or M.package_name(pyproject_path, setup_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/cpython"
    for _, target in ipairs(targets) do
        if target.output == nil then
            local source_base = target.source:match("^(.+)%.py$") or target.source
            target.output = bin_dir .. "/" .. source_base .. ".pyc"
        end
    end

    return {
        pyproject_path = pyproject_path,
        setup_path = setup_path,
        requirements_path = requirements_path,
        has_pyproject = pyproject_path ~= nil,
        has_setup = setup_path ~= nil,
        has_requirements = requirements_path ~= nil,
        has_installable = pyproject_path ~= nil or setup_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
