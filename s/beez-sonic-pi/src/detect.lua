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

local function is_sonic_pi_buffer(path)
    return path:match("/sonic%-pi/") ~= nil
        or path:match("/buffers/") ~= nil
        or path:match("/pi/") ~= nil
        or path:match("%.rb$") ~= nil
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
        prefix .. "/sonic-pi/**/*.rb",
        prefix .. "/buffers/**/*.rb",
        prefix .. "/pi/**/*.rb",
        prefix .. "/**/*.rb",
        prefix .. "/*.rb",
    })

    sort_shallow_first(files)

    for _, file in ipairs(files) do
        if not is_test_file(file) and is_sonic_pi_buffer(file) then
            return file
        end
    end

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
        prefix .. "/test/**/*.rb",
        prefix .. "/tests/**/*.rb",
        prefix .. "/**/test_*.rb",
        prefix .. "/**/*_test.rb",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local buffer_files = ctx.glob({ "**/*.rb" })

    if entry_source == nil and #buffer_files == 0 then
        error("sonic-pi plugin: no *.rb buffer files found — add a Sonic Pi buffer or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/sonic-pi/bin"
    local output_name = cfg.output_name or "app.wav"
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
