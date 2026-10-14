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

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.vale",
        prefix .. "src/main.vale",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    local sources = ctx.glob({ prefix .. "**/*.vale" })
    sort_shallow_first(sources)
    if #sources > 0 then
        return sources[1]
    end

    return nil
end

function M.module_name_from_source(source)
    if source == nil then
        return "main"
    end
    local name = basename(source):match("^(.+)%.vale$")
    return name or "main"
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.vale",
        prefix .. "tests/**/*.vale",
        prefix .. "**/*_test.vale",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local sources = ctx.glob({ "**/*.vale" })
    if #sources == 0 then
        error("vale plugin: no *.vale files found — add a Vale project or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    if entry_source == nil then
        error("vale plugin: no Vale entry point found — add main.vale or configure entry_source")
    end

    local bin_dir = cfg.bin_dir or "build/vale/bin"
    local output_name = cfg.output_name or "main"
    local module_name = cfg.module_name or M.module_name_from_source(entry_source)
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        module_name = module_name,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
