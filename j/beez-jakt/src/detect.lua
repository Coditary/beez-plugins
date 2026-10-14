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

function M.find_project_root(ctx)
    local candidates = ctx.glob({
        "main.jakt",
        "src/main.jakt",
        "**/main.jakt",
    })

    if #candidates == 0 then
        local sources = ctx.glob({ "**/*.jakt" })
        if #sources == 0 then
            return nil, nil
        end
        sort_shallow_first(sources)
        local entry = sources[1]
        return dirname(entry), entry
    end

    sort_shallow_first(candidates)
    local entry = candidates[1]
    return dirname(entry), entry
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.jakt",
        prefix .. "test/**/*.jakt",
        prefix .. "**/*_test.jakt",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root
    local entry_source = cfg.entry_source

    if root == nil or entry_source == nil then
        local detected_root, detected_entry = M.find_project_root(ctx)
        if detected_root == nil then
            error("jakt plugin: no *.jakt files found — add a Jakt project or set entry_source in configure()")
        end
        root = root or detected_root
        entry_source = entry_source or detected_entry
    end

    local bin_dir = cfg.bin_dir or "build/jakt/bin"
    local output_name = cfg.output_name or "app"
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
