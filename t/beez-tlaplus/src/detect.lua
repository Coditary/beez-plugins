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

local function basename_no_ext(path)
    local name = path:match("([^/]+)$") or path
    return name:gsub("%.[^%.]+$", "")
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
        prefix .. "/**/*.tla",
        prefix .. "/*.tla",
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

function M.resolve_config_source(ctx, root, entry_source, cfg_config)
    if cfg_config ~= nil and cfg_config ~= "" then
        return cfg_config
    end

    if entry_source == nil then
        return nil
    end

    local base = basename_no_ext(entry_source)
    local dir = entry_source:match("^(.*)/") or "."
    local candidates = ctx.glob({
        dir .. "/" .. base .. ".cfg",
        "**/" .. base .. ".cfg",
    })

    sort_shallow_first(candidates)

    if #candidates > 0 then
        return candidates[1]
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local cfg_files = ctx.glob({
        prefix .. "/**/*.cfg",
        prefix .. "/*.cfg",
    })

    sort_shallow_first(cfg_files)

    if #cfg_files > 0 then
        return cfg_files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.tla",
        prefix .. "/tests/**/*.tla",
        prefix .. "/**/test_*.tla",
        prefix .. "/**/*_test.tla",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local spec_files = ctx.glob({ "**/*.tla" })

    if entry_source == nil and #spec_files == 0 then
        error("tlaplus plugin: no *.tla files found — add a TLA+ spec or set entry_source in configure()")
    end

    local config_source = M.resolve_config_source(ctx, root, entry_source, cfg.config_source)
    local bin_dir = cfg.bin_dir or "build/tlaplus/bin"
    local output_name = cfg.output_name or "check.out"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        config_source = config_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
