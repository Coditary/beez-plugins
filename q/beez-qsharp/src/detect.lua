local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("_Test%.qs$") ~= nil
        or path:match("_test%.qs$") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end
    sort_shallow_first(files)
    return files[1]
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "Program.qs",
        prefix .. "src/Program.qs",
        prefix .. "src/Main.qs",
        prefix .. "Main.qs",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.qs" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not is_test_path(source) then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.qs" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not is_test_path(source) then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.qs",
        prefix .. "test/**/*.qs",
        prefix .. "**/*_Test.qs",
        prefix .. "**/*_test.qs",
    })

    return #test_files > 0
end

function M.project_root(csproj_path, entry_source)
    if csproj_path ~= nil then
        return dirname(csproj_path)
    end
    if entry_source ~= nil then
        return dirname(entry_source)
    end
    return "."
end

function M.resolve(ctx, cfg)
    local qs_files = ctx.glob({ "**/*.qs" })
    local csproj_path = cfg.csproj_path
    if csproj_path == nil then
        csproj_path = M.find_manifest(ctx, "*.csproj")
    end

    if #qs_files == 0 and csproj_path == nil then
        error("qsharp plugin: no *.qs or *.csproj files found — add a Q# project or set project_root in configure()")
    end

    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, cfg.project_root or ".")
    end

    local root = cfg.project_root or M.project_root(csproj_path, entry_source)
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/qsharp/bin"
    local primary_output
    if csproj_path ~= nil then
        primary_output = bin_dir .. "/" .. output_name .. ".dll"
    else
        primary_output = bin_dir .. "/" .. output_name .. ".qir"
    end

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root) or csproj_path ~= nil
    end

    return {
        project_root = root,
        csproj_path = csproj_path,
        has_csproj = csproj_path ~= nil,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
