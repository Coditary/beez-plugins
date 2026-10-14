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

local function read_file(path, max_bytes)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return ""
    end

    local content = file:read(max_bytes or 8192)
    file:close()
    return content or ""
end

function M.is_manim_file(path)
    local content = read_file(path)
    return content:match("from%s+manim%s+import") ~= nil
        or content:match("import%s+manim") ~= nil
        or content:match("from%s+manim%.") ~= nil
end

function M.resolve_scene_class(path, cfg_scene)
    if cfg_scene ~= nil and cfg_scene ~= "" then
        return cfg_scene
    end

    local content = read_file(path, 16384)
    local scene = content:match("class%s+(%w+)%s*%([^)]*Scene[^)]*%)")
    if scene ~= nil then
        return scene
    end

    return "Scene"
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local scene_dirs = ctx.glob({
        prefix .. "scenes/**/*.py",
        prefix .. "scenes/*.py",
    })
    sort_shallow_first(scene_dirs)

    for _, file in ipairs(scene_dirs) do
        if not is_test_file(file) and M.is_manim_file(file) then
            return file
        end
    end

    local py_files = ctx.glob({
        prefix .. "**/*.py",
        prefix .. "*.py",
    })
    sort_shallow_first(py_files)

    for _, file in ipairs(py_files) do
        if not is_test_file(file) and M.is_manim_file(file) then
            return file
        end
    end

    for _, file in ipairs(scene_dirs) do
        if not is_test_file(file) then
            return file
        end
    end

    if #py_files > 0 then
        for _, file in ipairs(py_files) do
            if not is_test_file(file) then
                return file
            end
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.py",
        prefix .. "tests/**/*.py",
        prefix .. "**/test_*.py",
        prefix .. "**/*_test.py",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local py_files = ctx.glob({ "**/*.py" })
    local scene_dirs = ctx.glob({ "scenes/**", "**/scenes/**" })
    local manim_files = {}

    for _, file in ipairs(py_files) do
        if M.is_manim_file(file) then
            manim_files[#manim_files + 1] = file
        end
    end

    if #manim_files == 0 and #scene_dirs == 0 and #py_files == 0 then
        error("manim plugin: no Manim *.py files or scenes/ found — add manim imports or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    if entry_source == nil then
        error("manim plugin: no Manim entry *.py found — add manim imports or set entry_source in configure()")
    end

    local scene_class = M.resolve_scene_class(entry_source, cfg.scene_class)
    local bin_dir = cfg.bin_dir or "build/manim/bin"
    local output_name = cfg.output_name or "app.mp4"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        scene_class = scene_class,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
        has_scenes_dir = #scene_dirs > 0,
    }
end

return M
