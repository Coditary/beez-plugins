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
end

function M.resolve_nqp_sources(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local patterns = {
        prefix .. "**/*.nqp",
        prefix .. "*.nqp",
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

function M.resolve_moar_files(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local patterns = {
        prefix .. "**/*.moar",
        prefix .. "*.moar",
    }

    local files = {}
    local seen = {}

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        for _, file in ipairs(matches) do
            if not seen[file] and not is_test_path(file) then
                seen[file] = true
                files[#files + 1] = file
            end
        end
    end

    sort_shallow_first(files)
    return files
end

function M.resolve_test_files(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local patterns = {
        prefix .. "t/**/*.nqp",
        prefix .. "t/*.nqp",
        prefix .. "t/**/*.t",
        prefix .. "t/*.t",
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

function M.project_root(nqp_sources, moar_files)
    if #nqp_sources > 0 then
        return dirname(nqp_sources[1])
    end
    if #moar_files > 0 then
        return dirname(moar_files[1])
    end
    return "."
end

function M.resolve(ctx, cfg)
    local project_root = cfg.project_root

    local nqp_sources = cfg.nqp_sources
    if nqp_sources == nil then
        nqp_sources = M.resolve_nqp_sources(ctx, project_root or ".")
    end

    local moar_files = cfg.moar_files
    if moar_files == nil then
        moar_files = M.resolve_moar_files(ctx, project_root or ".")
    end

    if #nqp_sources == 0 and #moar_files == 0 then
        error("moarvm plugin: no NQP (*.nqp) or MoarVM (*.moar) sources found — add sources or set project_root in configure()")
    end

    if project_root == nil then
        project_root = M.project_root(nqp_sources, moar_files)
    end

    local test_files = cfg.test_files
    if test_files == nil then
        test_files = M.resolve_test_files(ctx, project_root)
    end

    local bin_dir = cfg.bin_dir or "build/moarvm"

    return {
        project_root = project_root,
        nqp_sources = nqp_sources,
        moar_files = moar_files,
        test_files = test_files,
        bin_dir = bin_dir,
        primary_output = bin_dir .. "/.moarvm-compile",
        primary_source = nqp_sources[1] or moar_files[1],
    }
end

return M
