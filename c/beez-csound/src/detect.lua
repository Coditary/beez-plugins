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

    local csd_files = ctx.glob({
        prefix .. "/**/*.csd",
        prefix .. "/*.csd",
    })

    sort_shallow_first(csd_files)

    for _, file in ipairs(csd_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #csd_files > 0 then
        return csd_files[1]
    end

    local orc_files = ctx.glob({
        prefix .. "/**/*.orc",
        prefix .. "/*.orc",
    })

    sort_shallow_first(orc_files)

    for _, file in ipairs(orc_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #orc_files > 0 then
        return orc_files[1]
    end

    return nil
end

function M.resolve_score_source(ctx, entry_source, cfg_score)
    if cfg_score ~= nil and cfg_score ~= "" then
        return cfg_score
    end

    if entry_source == nil then
        return nil
    end

    if entry_source:match("%.csd$") then
        return nil
    end

    if not entry_source:match("%.orc$") then
        return nil
    end

    local base = basename_no_ext(entry_source)
    local dir = entry_source:match("^(.*)/") or "."
    local candidates = ctx.glob({
        dir .. "/" .. base .. ".sco",
        "**/" .. base .. ".sco",
    })

    sort_shallow_first(candidates)

    if #candidates > 0 then
        return candidates[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.csd",
        prefix .. "/tests/**/*.csd",
        prefix .. "/test/**/*.orc",
        prefix .. "/tests/**/*.orc",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local source_files = ctx.glob({ "**/*.csd", "**/*.orc", "**/*.sco" })

    if entry_source == nil and #source_files == 0 then
        error("csound plugin: no *.csd, *.orc, or *.sco files found — add Csound sources or set entry_source in configure()")
    end

    local score_source = M.resolve_score_source(ctx, entry_source, cfg.score_source)
    local bin_dir = cfg.bin_dir or "build/csound/bin"
    local output_name = cfg.output_name or "app.wav"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        score_source = score_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
