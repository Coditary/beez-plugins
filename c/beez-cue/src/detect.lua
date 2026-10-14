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

function M.has_module(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local modules = ctx.glob({
        prefix .. "/cue.mod/module.cue",
        prefix .. "/**/cue.mod/module.cue",
    })

    return #modules > 0
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local module = ctx.glob({
        prefix .. "/cue.mod/module.cue",
        prefix .. "/**/cue.mod/module.cue",
    })
    if #module > 0 then
        sort_shallow_first(module)
        return module[1]
    end

    for _, name in ipairs({ "main.cue", "config.cue", "schema.cue" }) do
        local candidates = ctx.glob({
            prefix .. "/" .. name,
            prefix .. "/**/" .. name,
        })
        if #candidates > 0 then
            sort_shallow_first(candidates)
            return candidates[1]
        end
    end

    local files = ctx.glob({
        prefix .. "/**/*.cue",
        prefix .. "/*.cue",
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
        prefix .. "/test/**/*.cue",
        prefix .. "/tests/**/*.cue",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local cue_files = ctx.glob({ "**/*.cue", "cue.mod/module.cue" })

    if entry_source == nil and #cue_files == 0 then
        error("cue plugin: no *.cue or cue.mod/module.cue files found — add CUE sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/cue/bin"
    local output_name = cfg.output_name or "export.json"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end
    local has_module = cfg.has_module
    if has_module == nil then
        has_module = M.has_module(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
        has_module = has_module,
    }
end

return M
