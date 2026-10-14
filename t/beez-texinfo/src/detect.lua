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

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.texi",
        prefix .. "index.texi",
        prefix .. "doc.texi",
        prefix .. "manual.texi",
        prefix .. "main.texinfo",
        prefix .. "index.texinfo",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_texi = ctx.glob({ prefix .. "*.texi", prefix .. "*.texinfo" })
    sort_shallow_first(root_texi)
    if #root_texi > 0 then
        return root_texi[1]
    end

    local all_texi = ctx.glob({ prefix .. "**/*.texi", prefix .. "**/*.texinfo" })
    sort_shallow_first(all_texi)
    if #all_texi > 0 then
        return all_texi[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.texi",
        prefix .. "test/**/*.texi",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local texi_files = ctx.glob({ "**/*.texi", "**/*.texinfo" })

    if #texi_files == 0 then
        error("texinfo plugin: no *.texi files found — add Texinfo source or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "index.html"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local out_dir = cfg.out_dir or "build/texinfo/out"
    local primary_output = out_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        out_dir = out_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
