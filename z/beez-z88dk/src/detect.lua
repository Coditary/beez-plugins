local M = {}

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

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.c",
        prefix .. "src/main.c",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.c" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("_test%.c$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.c" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("_test%.c$")
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
        prefix .. "**/*_test.c",
        prefix .. "test/**/*.c",
        prefix .. "tests/**/*.c",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local c_files = ctx.glob({ "**/*.c" })
    if #c_files == 0 then
        error("z88dk plugin: no *.c files found — add a Z80 C project or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/z88dk/bin"
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
