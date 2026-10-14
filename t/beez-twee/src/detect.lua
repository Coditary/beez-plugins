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

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.twee",
        prefix .. "story.twee",
        prefix .. "index.twee",
        prefix .. "main.tw",
        prefix .. "story.tw",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.twee", prefix .. "*.tw" })
    sort_shallow_first(root_files)
    for _, file in ipairs(root_files) do
        if not is_test_file(file) then
            return file
        end
    end

    local all = ctx.glob({ prefix .. "**/*.twee", prefix .. "**/*.tw" })
    sort_shallow_first(all)
    for _, file in ipairs(all) do
        if not is_test_file(file) then
            return file
        end
    end

    if #all > 0 then
        return all[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.twee",
        prefix .. "tests/**/*.twee",
        prefix .. "test/**/*.tw",
        prefix .. "tests/**/*.tw",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local source_files = ctx.glob({ "**/*.twee", "**/*.tw" })

    if #source_files == 0 then
        error("twee plugin: no *.twee or *.tw files found — add a Twee story or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local bin_dir = cfg.bin_dir or "build/twee/bin"
    local output_name = cfg.output_name or "app.html"
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
