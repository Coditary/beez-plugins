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

function M.find_kv_files(ctx)
    return ctx.glob({ "**/*.kv" })
end

function M.project_root(kv_path, pyproject_path, requirements_path)
    if kv_path ~= nil then
        return dirname(kv_path)
    end
    if pyproject_path ~= nil then
        return dirname(pyproject_path)
    end
    if requirements_path ~= nil then
        return dirname(requirements_path)
    end
    return "."
end

function M.package_name(kv_path, pyproject_path)
    if kv_path ~= nil then
        local name = basename(kv_path):match("^(.+)%.kv$")
        if name ~= nil and name ~= "" then
            return name
        end
    end
    if pyproject_path ~= nil then
        local name = basename(dirname(pyproject_path))
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

    local kv_candidates = {
        prefix .. "main.kv",
        prefix .. package_name .. ".kv",
        prefix .. "app.kv",
    }

    for _, pattern in ipairs(kv_candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
                    kind = "kv",
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
        local kv_files = ctx.glob({ prefix .. "**/*.kv" })
        sort_shallow_first(kv_files)
        for _, source in ipairs(kv_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.kv$") or package_name,
                    kind = "kv",
                    output = nil,
                }
                break
            end
        end
    end

    local py_candidates = {
        prefix .. "main.py",
        prefix .. "src/main.py",
        prefix .. package_name .. ".py",
        prefix .. "src/" .. package_name .. "/__main__.py",
        prefix .. package_name .. "/__main__.py",
    }

    for _, pattern in ipairs(py_candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = package_name,
                    kind = "py",
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local py_files = ctx.glob({ prefix .. "**/*.py" })
        sort_shallow_first(py_files)
        for _, source in ipairs(py_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = basename(source):match("^(.+)%.py$") or package_name,
                    kind = "py",
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("kivy plugin: no .kv or .py entry point found — add main.kv/main.py or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local kv_files = M.find_kv_files(ctx)

    local pyproject_path = cfg.pyproject_path
    if pyproject_path == nil then
        pyproject_path = M.find_manifest(ctx, "pyproject.toml")
    end

    local requirements_path = cfg.requirements_path
    if requirements_path == nil then
        requirements_path = M.find_manifest(ctx, "requirements.txt")
    end

    local py_files = ctx.glob({ "**/*.py" })
    if #kv_files == 0 and pyproject_path == nil and requirements_path == nil and #py_files == 0 then
        error("kivy plugin: no *.kv, pyproject.toml, requirements.txt, or *.py files found")
    end

    local primary_kv = kv_files[1]
    if primary_kv ~= nil then
        sort_shallow_first(kv_files)
        primary_kv = kv_files[1]
    end

    local root = cfg.project_root or M.project_root(primary_kv, pyproject_path, requirements_path)
    local output_name = cfg.output_name or M.package_name(primary_kv, pyproject_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/kivy"
    for _, target in ipairs(targets) do
        if target.output == nil then
            if target.kind == "kv" then
                target.output = bin_dir .. "/" .. target.name .. ".kv.ok"
            else
                local source_base = target.source:match("^(.+)%.py$") or target.source
                target.output = bin_dir .. "/" .. source_base .. ".pyc"
            end
        end
    end

    local primary_kv_target = nil
    local primary_py_target = nil
    for _, target in ipairs(targets) do
        if target.kind == "kv" and primary_kv_target == nil then
            primary_kv_target = target
        end
        if target.kind == "py" and primary_py_target == nil then
            primary_py_target = target
        end
    end

    return {
        pyproject_path = pyproject_path,
        requirements_path = requirements_path,
        has_pyproject = pyproject_path ~= nil,
        has_requirements = requirements_path ~= nil,
        has_installable = pyproject_path ~= nil,
        kv_files = kv_files,
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_kv = primary_kv_target,
        primary_py = primary_py_target,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
