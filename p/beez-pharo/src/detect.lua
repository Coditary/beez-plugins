local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

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

local function find_first(ctx, patterns)
    local matches = ctx.glob(patterns)
    if #matches == 0 then
        return nil
    end

    sort_shallow_first(matches)
    return matches[1]
end

function M.find_image(ctx)
    local pharo = find_first(ctx, { "Pharo.image", "**/Pharo.image" })
    if pharo ~= nil then
        return pharo
    end

    return find_first(ctx, { "*.image", "**/*.image" })
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.is_test_path(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("-test%.st$") ~= nil
        or path:match("Test%.st$") ~= nil
        or path:match("^test/") ~= nil
        or path:match("^tests/") ~= nil
end

function M.find_source_files(ctx, root)
    local prefix = glob_prefix(root)
    local sources = ctx.glob({
        prefix .. "**/*.st",
        prefix .. "*.st",
    })

    local filtered = {}
    for _, path in ipairs(sources) do
        if not M.is_test_path(path) then
            filtered[#filtered + 1] = path
        end
    end

    sort_shallow_first(filtered)
    return filtered
end

function M.find_compile_script(ctx, root)
    local prefix = glob_prefix(root)
    return find_first(ctx, {
        prefix .. "scripts/compile.st",
        prefix .. "compile.st",
        "scripts/compile.st",
        "compile.st",
    })
end

function M.find_test_script(ctx, root)
    local prefix = glob_prefix(root)
    return find_first(ctx, {
        prefix .. "scripts/test.st",
        prefix .. "tests/run.st",
        prefix .. "test.st",
        "scripts/test.st",
        "tests/run.st",
        "test.st",
    })
end

function M.has_test_sources(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.st",
        prefix .. "test/**/*.st",
        prefix .. "**/*-test.st",
        prefix .. "**/*Test.st",
    })
    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local image_path = cfg.image_path or M.find_image(ctx)
    local root = cfg.project_root

    if root == nil then
        if image_path ~= nil then
            root = dirname(image_path)
        else
            root = "."
        end
    end

    local sources = cfg.source_files
    if sources == nil then
        sources = M.find_source_files(ctx, root)
    end

    if image_path == nil and #sources == 0 then
        error("pharo plugin: no Pharo.image or **/*.st found — add a Pharo/Squeak project or set image_path in configure()")
    end

    local compile_script = cfg.compile_script or M.find_compile_script(ctx, root)
    local test_script = cfg.test_script or M.find_test_script(ctx, root)
    local build_dir = cfg.build_dir or "build/pharo"

    return {
        image_path = image_path,
        has_image = image_path ~= nil,
        project_root = root,
        source_files = sources,
        compile_script = compile_script,
        test_script = test_script,
        has_tests = test_script ~= nil or M.has_test_sources(ctx, root),
        build_dir = build_dir,
        bin_dir = cfg.bin_dir or build_dir,
        primary_output = build_dir,
    }
end

return M
