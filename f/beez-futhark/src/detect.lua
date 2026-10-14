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
        or path:match("_test%.fut$") ~= nil
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.fut",
        prefix .. "program.fut",
        prefix .. "src/main.fut",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.fut" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not is_test_path(source) then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.fut" })
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
        prefix .. "tests/**/*.fut",
        prefix .. "test/**/*.fut",
        prefix .. "**/*_test.fut",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local fut_files = ctx.glob({ "**/*.fut" })

    if #fut_files == 0 then
        error("futhark plugin: no *.fut files found — add a Futhark program or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    if entry_source == nil then
        error("futhark plugin: no entry *.fut found — add main.fut or configure entry_source")
    end

    local output_name = cfg.output_name or basename(entry_source):match("^(.+)%.fut$") or "app"
    local bin_dir = cfg.bin_dir or "build/futhark/bin"
    local primary_output = bin_dir .. "/" .. output_name

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
