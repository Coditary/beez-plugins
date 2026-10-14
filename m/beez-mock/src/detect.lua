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

function M.resolve_mock_config(ctx, root, cfg_config)
    if cfg_config ~= nil and cfg_config ~= "" then
        return cfg_config
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local configs = ctx.glob({
        prefix .. "/mock.cfg",
        prefix .. "/**/mock.cfg",
        prefix .. "/site-defaults.cfg",
        prefix .. "/**/site-defaults.cfg",
    })

    if #configs > 0 then
        sort_shallow_first(configs)
        return configs[1]
    end

    return nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*.spec",
        prefix .. "/*.spec",
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

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local mock_config = M.resolve_mock_config(ctx, root, cfg.mock_config_file)
    local spec_files = ctx.glob({ "**/*.spec" })
    local config_files = ctx.glob({ "mock.cfg", "**/mock.cfg", "site-defaults.cfg", "**/site-defaults.cfg" })

    if entry_source == nil and #spec_files == 0 then
        error("mock plugin: no *.spec files found — add RPM spec files or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/mock/bin"
    local output_name = cfg.output_name or "build.ok"
    local primary_output = bin_dir .. "/" .. output_name

    return {
        project_root = root,
        entry_source = entry_source,
        mock_config_file = mock_config,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_mock_config = #config_files > 0 or mock_config ~= nil,
    }
end

return M
