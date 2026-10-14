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
        prefix .. "/parser.mly",
        prefix .. "/grammar.mly",
        prefix .. "/**/parser.mly",
        prefix .. "/**/grammar.mly",
    })
    if #preferred > 0 then
        sort_shallow_first(preferred)
        return preferred[1]
    end

    local files = ctx.glob({
        prefix .. "/**/*.mly",
        prefix .. "/*.mly",
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
        prefix .. "/test/**/*.mly",
        prefix .. "/tests/**/*.mly",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local grammar_files = ctx.glob({ "**/*.mly" })

    if entry_source == nil and #grammar_files == 0 then
        error("menhir plugin: no *.mly files found — add grammar sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/menhir/bin"
    local base_name = cfg.base_name or "parser"
    local output_name = cfg.output_name or (base_name .. ".ml")
    local interface_name = cfg.interface_name or (base_name .. ".mli")
    local primary_output = bin_dir .. "/" .. output_name
    local interface_output = bin_dir .. "/" .. interface_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        base_name = base_name,
        output_name = output_name,
        interface_name = interface_name,
        primary_output = primary_output,
        interface_output = interface_output,
        has_tests = has_tests,
    }
end

return M
