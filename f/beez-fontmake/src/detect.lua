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

function M.entry_kind(path)
    if path == nil then
        return nil
    end
    if path:match("%.designspace$") then
        return "designspace"
    end
    if path:match("%.glyphs$") then
        return "glyphs"
    end
    if path:match("%.ufo/?$") or path:match("%.ufo/") then
        return "ufo"
    end
    return nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local patterns = {
        { kind = "designspace", globs = { prefix .. "**/*.designspace", prefix .. "*.designspace" } },
        { kind = "glyphs", globs = { prefix .. "**/*.glyphs", prefix .. "*.glyphs" } },
        { kind = "ufo", globs = { prefix .. "**/*.ufo", prefix .. "*.ufo" } },
    }

    for _, pattern in ipairs(patterns) do
        local files = ctx.glob(pattern.globs)
        sort_shallow_first(files)
        for _, file in ipairs(files) do
            if not is_test_file(file) then
                return file
            end
        end
        if #files > 0 then
            return files[1]
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.designspace",
        prefix .. "tests/**/*.designspace",
        prefix .. "test/**/*.glyphs",
        prefix .. "tests/**/*.glyphs",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local source_files = ctx.glob({
        "**/*.designspace",
        "**/*.ufo",
        "**/*.glyphs",
    })

    if #source_files == 0 then
        error("fontmake plugin: no *.designspace, *.ufo, or *.glyphs files found — add font sources or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local entry_kind = M.entry_kind(entry_source)
    if entry_kind == nil then
        entry_kind = M.entry_kind(source_files[1])
    end

    local bin_dir = cfg.bin_dir or "build/fontmake/bin"
    local output_name = cfg.output_name or "app.otf"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        entry_kind = entry_kind,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
