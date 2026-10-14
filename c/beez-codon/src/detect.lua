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

function M.project_root(codon_yml_path)
    if codon_yml_path ~= nil then
        return dirname(codon_yml_path)
    end
    return "."
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
        prefix .. "main.py",
        prefix .. "src/main.py",
        prefix .. "app.py",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 and not is_test_path(matches[1]) then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.py" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not is_test_path(source) then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.py" })
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
        prefix .. "tests/**/*.py",
        prefix .. "test/**/*.py",
        prefix .. "**/test_*.py",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local codon_yml_path = cfg.codon_yml_path
    if codon_yml_path == nil then
        codon_yml_path = M.find_manifest(ctx, "codon.yml")
    end

    local py_files = ctx.glob({ "**/*.py" })
    if codon_yml_path == nil and #py_files == 0 then
        error("codon plugin: no codon.yml or *.py files found — add a Codon project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(codon_yml_path)
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    if entry_source == nil then
        error("codon plugin: no .py entry point found — add main.py or configure entry_source")
    end

    local bin_dir = cfg.bin_dir or "build/codon/bin"
    local primary_output = bin_dir .. "/" .. output_name

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        codon_yml_path = codon_yml_path,
        has_codon_yml = codon_yml_path ~= nil,
        project_root = root,
        entry_source = entry_source,
        output_name = output_name,
        bin_dir = bin_dir,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
