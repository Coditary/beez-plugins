local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function depth(path)
    return select(2, path:gsub("/", ""))
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = depth(a)
        local depth_b = depth(b)
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

local function is_test_path(path)
    return path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("_test%.") ~= nil
        or path:match("%.t$") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.resolve_sources(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local patterns = {
        prefix .. "**/*.raku",
        prefix .. "**/*.rakumod",
        prefix .. "**/*.pm6",
        prefix .. "*.raku",
        prefix .. "*.rakumod",
        prefix .. "*.pm6",
    }

    local sources = {}
    local seen = {}

    for _, pattern in ipairs(patterns) do
        local files = ctx.glob({ pattern })
        for _, file in ipairs(files) do
            if not seen[file] and not is_test_path(file) then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
    end

    sort_shallow_first(sources)
    return sources
end

function M.resolve_test_files(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local patterns = {
        prefix .. "t/**/*.t",
        prefix .. "t/*.t",
        prefix .. "t/**/*.rakutest",
        prefix .. "t/*.rakutest",
    }

    local tests = {}
    local seen = {}

    for _, pattern in ipairs(patterns) do
        local files = ctx.glob({ pattern })
        for _, file in ipairs(files) do
            if not seen[file] then
                seen[file] = true
                tests[#tests + 1] = file
            end
        end
    end

    sort_shallow_first(tests)
    return tests
end

function M.resolve(ctx, cfg)
    local meta6_path = cfg.meta6_path
    if meta6_path == nil then
        meta6_path = M.find_manifest(ctx, "META6.json")
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if meta6_path ~= nil then
            project_root = dirname(meta6_path)
        else
            project_root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_sources(ctx, project_root)
    end

    if meta6_path == nil and #sources == 0 then
        error("rakudo plugin: no META6.json or Raku sources (*.raku, *.rakumod, *.pm6) found — add a Raku project or set project_root in configure()")
    end

    if #sources == 0 then
        error("rakudo plugin: no Raku sources found — add .raku, .rakumod, or .pm6 files")
    end

    local test_files = cfg.test_files
    if test_files == nil then
        test_files = M.resolve_test_files(ctx, project_root)
    end

    local bin_dir = cfg.bin_dir or "build/rakudo"

    return {
        meta6_path = meta6_path,
        has_meta6 = meta6_path ~= nil,
        project_root = project_root,
        sources = sources,
        test_files = test_files,
        bin_dir = bin_dir,
        primary_output = bin_dir .. "/.rakudo-compile",
        primary_source = sources[1],
    }
end

return M
