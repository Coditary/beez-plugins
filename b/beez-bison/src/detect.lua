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

local function is_test_file(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("test_") ~= nil
        or path:match("_test%.") ~= nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local preferred = ctx.glob({
        prefix .. "/grammar.y",
        prefix .. "/parser.y",
        prefix .. "/**/grammar.y",
        prefix .. "/**/parser.y",
    })
    if #preferred > 0 then
        sort_shallow_first(preferred)
        return preferred[1]
    end

    local files = ctx.glob({
        prefix .. "/**/*.y",
        prefix .. "/*.y",
        prefix .. "/**/*.yy",
        prefix .. "/*.yy",
        prefix .. "/**/*.yacc",
        prefix .. "/*.yacc",
    })

    sort_shallow_first(files)

    for _, file in ipairs(files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #files > 0 then
        return files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.y",
        prefix .. "/tests/**/*.y",
        prefix .. "/test/**/*.yy",
        prefix .. "/tests/**/*.yy",
        prefix .. "/test/**/*.yacc",
        prefix .. "/tests/**/*.yacc",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local grammar_files = ctx.glob({ "**/*.y", "**/*.yy", "**/*.yacc" })

    if entry_source == nil and #grammar_files == 0 then
        error("bison plugin: no *.y, *.yy, or *.yacc files found — add grammar sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/bison/bin"
    local output_name = cfg.output_name or "parser.tab.c"
    local header_name = cfg.header_name or "parser.tab.h"
    local primary_output = bin_dir .. "/" .. output_name
    local header_output = bin_dir .. "/" .. header_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        header_name = header_name,
        primary_output = primary_output,
        header_output = header_output,
        has_tests = has_tests,
    }
end

return M
