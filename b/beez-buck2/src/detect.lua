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

function M.has_buckconfig(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local configs = ctx.glob({
        prefix .. "/.buckconfig",
        prefix .. "/**/.buckconfig",
    })

    return #configs > 0
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local buckconfig = ctx.glob({
        prefix .. "/.buckconfig",
    })
    if #buckconfig > 0 then
        return buckconfig[1]
    end

    local buck_file = ctx.glob({
        prefix .. "/BUCK",
        prefix .. "/**/BUCK",
    })
    if #buck_file > 0 then
        sort_shallow_first(buck_file)
        return buck_file[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_bucks = ctx.glob({
        prefix .. "/test/**/BUCK",
        prefix .. "/tests/**/BUCK",
    })

    return #test_bucks > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local buck_files = ctx.glob({ "BUCK", ".buckconfig", "**/BUCK" })

    if entry_source == nil and #buck_files == 0 then
        error("buck2 plugin: no BUCK or .buckconfig files found — add Buck2 sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/buck2/bin"
    local output_name = cfg.output_name or "build.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local has_buckconfig = cfg.has_buckconfig
    if has_buckconfig == nil then
        has_buckconfig = M.has_buckconfig(ctx, root)
    end
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
        has_buckconfig = has_buckconfig,
        has_tests = has_tests,
    }
end

return M
