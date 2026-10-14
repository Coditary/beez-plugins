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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("_test%.qasm$") ~= nil
        or path:match("_Test%.qasm$") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end
    sort_shallow_first(files)
    return files[1]
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.qasm",
        prefix .. "circuit.qasm",
        prefix .. "src/main.qasm",
        prefix .. "src/circuit.qasm",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.qasm" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not is_test_path(source) then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.qasm" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not is_test_path(source) then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.qasm",
        prefix .. "test/**/*.qasm",
        prefix .. "tests/**/*.py",
        prefix .. "test/**/*.py",
        prefix .. "**/*_test.qasm",
    })

    return #test_files > 0
end

function M.project_root(requirements_path, entry_source)
    if requirements_path ~= nil then
        return dirname(requirements_path)
    end
    if entry_source ~= nil then
        return dirname(entry_source)
    end
    return "."
end

function M.resolve(ctx, cfg)
    local qasm_files = ctx.glob({ "**/*.qasm" })
    local requirements_path = cfg.requirements_path
    if requirements_path == nil then
        requirements_path = M.find_manifest(ctx, "requirements.txt")
    end

    if #qasm_files == 0 and requirements_path == nil then
        error("qiskit plugin: no *.qasm or requirements.txt files found — add an OpenQASM project or set project_root in configure()")
    end

    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, cfg.project_root or ".")
    end

    local root = cfg.project_root or M.project_root(requirements_path, entry_source)
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/qiskit/bin"
    local primary_output = bin_dir .. "/" .. output_name .. ".qasm"

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        requirements_path = requirements_path,
        has_requirements = requirements_path ~= nil,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
