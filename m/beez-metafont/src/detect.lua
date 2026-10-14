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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function is_test_file(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("test_") ~= nil
        or path:match("_test%.") ~= nil
end

local function basename_without_ext(path)
    local name = path:match("([^/]+)$") or path
    return name:gsub("%.mf$", ""):gsub("%.fd$", "")
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local mf_files = ctx.glob({
        prefix .. "**/*.mf",
        prefix .. "*.mf",
    })

    sort_shallow_first(mf_files)

    for _, file in ipairs(mf_files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #mf_files > 0 then
        return mf_files[1]
    end

    local fd_files = ctx.glob({
        prefix .. "**/*.fd",
        prefix .. "*.fd",
    })

    sort_shallow_first(fd_files)
    if #fd_files > 0 then
        return fd_files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.mf",
        prefix .. "tests/**/*.mf",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local source_files = ctx.glob({ "**/*.mf", "**/*.fd" })

    if #source_files == 0 then
        error("metafont plugin: no *.mf or *.fd files found — add font sources or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local jobname = cfg.jobname
    if jobname == nil or jobname == "" then
        jobname = basename_without_ext(entry_source or source_files[1])
    end

    local bin_dir = cfg.bin_dir or "build/metafont/bin"
    local output_name = cfg.output_name or (jobname .. ".gf")
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        jobname = jobname,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
