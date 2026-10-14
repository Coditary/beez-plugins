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

function M.resolve_config_dir(ctx, root, cfg_dir)
    if cfg_dir ~= nil and cfg_dir ~= "" then
        return cfg_dir
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local eww_yuck = ctx.glob({
        prefix .. "/eww.yuck",
        prefix .. "/**/eww.yuck",
    })
    if #eww_yuck > 0 then
        sort_shallow_first(eww_yuck)
        local path = eww_yuck[1]
        return path:match("^(.*)/[^/]+$") or "."
    end

    return root
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local eww_yuck = ctx.glob({
        prefix .. "/eww.yuck",
        prefix .. "/**/eww.yuck",
    })
    if #eww_yuck > 0 then
        sort_shallow_first(eww_yuck)
        return eww_yuck[1]
    end

    local files = ctx.glob({
        prefix .. "/**/*.yuck",
        prefix .. "/*.yuck",
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
        prefix .. "/test/**/*.yuck",
        prefix .. "/tests/**/*.yuck",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local yuck_files = ctx.glob({ "eww.yuck", "**/*.yuck" })
    local config_dir = M.resolve_config_dir(ctx, root, cfg.config_dir)

    if entry_source == nil and #yuck_files == 0 then
        error("yuck plugin: no eww.yuck or *.yuck files found — add Eww widget sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/yuck/bin"
    local output_name = cfg.output_name or "validate.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        config_dir = config_dir,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
