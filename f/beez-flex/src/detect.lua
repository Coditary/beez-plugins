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
        prefix .. "/lexer.l",
        prefix .. "/scanner.l",
        prefix .. "/**/lexer.l",
        prefix .. "/**/scanner.l",
        prefix .. "/lexer.lex",
        prefix .. "/scanner.lex",
    })
    if #preferred > 0 then
        sort_shallow_first(preferred)
        return preferred[1]
    end

    local files = ctx.glob({
        prefix .. "/**/*.l",
        prefix .. "/*.l",
        prefix .. "/**/*.lex",
        prefix .. "/*.lex",
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
        prefix .. "/test/**/*.l",
        prefix .. "/tests/**/*.l",
        prefix .. "/test/**/*.lex",
        prefix .. "/tests/**/*.lex",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local lexer_files = ctx.glob({ "**/*.l", "**/*.lex" })

    if entry_source == nil and #lexer_files == 0 then
        error("flex plugin: no *.l or *.lex files found — add lexer sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/flex/bin"
    local output_name = cfg.output_name or "lex.yy.c"
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
