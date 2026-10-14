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

function M.find_setup_py(ctx)
    local files = ctx.glob({ "setup.py", "**/setup.py" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_pyproject(ctx)
    local files = ctx.glob({ "pyproject.toml", "**/pyproject.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(setup_py_path, pyproject_path)
    if setup_py_path ~= nil then
        return dirname(setup_py_path)
    end
    if pyproject_path ~= nil then
        return dirname(pyproject_path)
    end
    return "."
end

function M.package_name(setup_py_path, pyproject_path)
    if setup_py_path ~= nil then
        return basename(setup_py_path):match("^(.+)%.py$") or "app"
    end
    if pyproject_path ~= nil then
        return basename(dirname(pyproject_path))
    end
    return "app"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local pyx_files = ctx.glob({ prefix .. "**/*.pyx" })
    sort_shallow_first(pyx_files)

    for _, source in ipairs(pyx_files) do
        if not seen[source] then
            seen[source] = true
            local name = basename(source):match("^(.+)%.pyx$") or basename(source)
            targets[#targets + 1] = {
                source = source,
                name = name,
            }
        end
    end

    if #targets == 0 then
        local py_files = ctx.glob({ prefix .. "src/*.py", prefix .. "*.py" })
        sort_shallow_first(py_files)
        for _, source in ipairs(py_files) do
            if not source:match("/tests/") and not source:match("/test/") and not source:match("__init__") then
                local name = basename(source):match("^(.+)%.py$") or basename(source)
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                }
                break
            end
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local setup_py_path = cfg.setup_py_path
    if setup_py_path == nil then
        setup_py_path = M.find_setup_py(ctx)
    end

    local pyproject_path = cfg.pyproject_path
    if pyproject_path == nil then
        pyproject_path = M.find_pyproject(ctx)
    end

    local pyx_files = ctx.glob({ "**/*.pyx" })
    local py_files = ctx.glob({ "**/*.py" })

    if setup_py_path == nil and pyproject_path == nil and #pyx_files == 0 and #py_files == 0 then
        error("cython plugin: no setup.py, pyproject.toml, *.pyx, or *.py files found — add a Cython project or set setup_py_path in configure()")
    end

    local root = cfg.project_root or M.project_root(setup_py_path, pyproject_path)
    local package_name = cfg.package_name or M.package_name(setup_py_path, pyproject_path)
    local lib_dir = cfg.lib_dir or "build/cython/lib"
    local temp_dir = cfg.temp_dir or "build/cython/temp"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    if setup_py_path == nil and pyproject_path == nil and #targets == 0 then
        error("cython plugin: no setup.py, pyproject.toml, or .pyx entry point found — add setup.py or *.pyx sources")
    end

    return {
        setup_py_path = setup_py_path,
        pyproject_path = pyproject_path,
        has_setup_py = setup_py_path ~= nil,
        has_pyproject = pyproject_path ~= nil,
        project_root = root,
        package_name = package_name,
        targets = targets,
        lib_dir = lib_dir,
        temp_dir = temp_dir,
        primary_source = targets[1] and targets[1].source or nil,
    }
end

return M
