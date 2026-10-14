local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
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

function M.entry_basename(entry_source)
    local name = basename(entry_source)
    return name:match("^(.+)%.inko$") or "app"
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "src/main.inko",
        prefix .. "main.inko",
        prefix .. "src/app.inko",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local src_files = ctx.glob({ prefix .. "src/*.inko" })
    sort_shallow_first(src_files)
    if #src_files > 0 then
        return src_files[1]
    end

    local root_files = ctx.glob({ prefix .. "*.inko" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("_test%.inko$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.inko" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("_test%.inko$")
            and not source:match("/tests/")
            and not source:match("/test/") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.inko",
        prefix .. "test/**/*.inko",
        prefix .. "**/*_test.inko",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local inko_files = ctx.glob({ "**/*.inko" })
    if #inko_files == 0 then
        error("inko plugin: no *.inko files found — add an Inko project or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    if entry_source == nil then
        error("inko plugin: no .inko entry point found — add src/main.inko or configure entry_source")
    end

    local bin_dir = cfg.bin_dir or "build/inko/bin"
    local entry_base = M.entry_basename(entry_source)
    local primary_output = bin_dir .. "/" .. output_name

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        entry_base = entry_base,
        output_name = output_name,
        bin_dir = bin_dir,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
