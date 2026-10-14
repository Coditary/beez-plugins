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

function M.find_pyproject(ctx)
    local files = ctx.glob({ "pyproject.toml", "**/pyproject.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_requirements(ctx)
    local files = ctx.glob({ "requirements.txt", "**/requirements.txt" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(pyproject_path)
    if pyproject_path == nil then
        return "."
    end
    return dirname(pyproject_path)
end

function M.module_name(source_path)
    local name = basename(source_path):match("^(.+)%.py$")
    return name or "app"
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
        prefix .. "main.py",
        prefix .. "app.py",
        prefix .. "src/main.py",
        prefix .. "src/app.py",
        prefix .. "__main__.py",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                local name = M.module_name(source)
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
        local src_files = ctx.glob({ prefix .. "src/**/*.py" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if source:match("/__main__%.py$") then
                local name = basename(dirname(source))
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
        local root_files = ctx.glob({ prefix .. "*.py" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not source:match("^setup%.py$") and not source:match("^conftest%.py$") then
                local name = M.module_name(source)
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
        error("nuitka plugin: no Python entry point found — add main.py or configure targets")
    end

    if output_name ~= nil and output_name ~= "" and output_name ~= "app" then
        targets[1].name = output_name
    end

    return targets
end

function M.resolve(ctx, cfg)
    local pyproject_path = cfg.pyproject_path
    if pyproject_path == nil then
        pyproject_path = M.find_pyproject(ctx)
    end

    local py_files = ctx.glob({ "**/*.py" })
    if pyproject_path == nil and #py_files == 0 then
        error("nuitka plugin: no pyproject.toml or *.py files found — add a Python project or set pyproject_path in configure()")
    end

    local root = cfg.project_root or M.project_root(pyproject_path)
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/nuitka/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name .. ".dist/" .. target.name
        end
    end

    return {
        pyproject_path = pyproject_path,
        requirements_path = cfg.requirements_path or M.find_requirements(ctx),
        has_pyproject = pyproject_path ~= nil,
        project_root = root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
