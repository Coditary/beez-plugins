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

    local drl_files = ctx.glob({
        prefix .. "/**/*.drl",
        prefix .. "/*.drl",
    })

    sort_shallow_first(drl_files)

    for _, file in ipairs(drl_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #drl_files > 0 then
        return drl_files[1]
    end

    return nil
end

function M.resolve_dsl_source(ctx, root, cfg_dsl)
    if cfg_dsl ~= nil and cfg_dsl ~= "" then
        return cfg_dsl
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local dsl_files = ctx.glob({
        prefix .. "/**/*.dsl",
        prefix .. "/*.dsl",
    })

    sort_shallow_first(dsl_files)

    for _, file in ipairs(dsl_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #dsl_files > 0 then
        return dsl_files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.drl",
        prefix .. "/tests/**/*.drl",
        prefix .. "/test/**/*.dsl",
        prefix .. "/tests/**/*.dsl",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local source_files = ctx.glob({ "**/*.drl", "**/*.dsl" })

    if entry_source == nil and #source_files == 0 then
        error("drools plugin: no *.drl or *.dsl files found — add Drools rules or set entry_source in configure()")
    end

    local dsl_source = M.resolve_dsl_source(ctx, root, cfg.dsl_source)
    local bin_dir = cfg.bin_dir or "build/drools/bin"
    local output_name = cfg.output_name or "rules.jar"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        dsl_source = dsl_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
