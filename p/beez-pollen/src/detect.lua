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
        prefix .. "index.pmd",
        prefix .. "main.pmd",
        prefix .. "document.pmd",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local root_files = ctx.glob({ prefix .. "*.pmd" })
    sort_shallow_first(root_files)
    for _, source in ipairs(root_files) do
        if not source:match("_test%.pmd$") then
            return source
        end
    end

    local all = ctx.glob({ prefix .. "**/*.pmd" })
    sort_shallow_first(all)
    for _, source in ipairs(all) do
        if not source:match("_test%.pmd$") and not source:match("/tests/") and not source:match("/test/") then
            return source
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.pmd",
        prefix .. "test/**/*.pmd",
        prefix .. "**/*_test.pmd",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local pmd_files = ctx.glob({ "**/*.pmd" })
    local pollen_rkt = ctx.glob({ "pollen.rkt", "**/pollen.rkt" })

    if #pmd_files == 0 and #pollen_rkt == 0 then
        error("pollen plugin: no *.pmd or pollen.rkt found — add a Pollen project or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "main"
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local out_dir = cfg.out_dir or "build/pollen/out"
    local primary_output = out_dir .. "/" .. output_name .. ".html"
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
        has_pollen_rkt = #pollen_rkt > 0,
    }
end

return M
