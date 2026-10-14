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
        or path:match("_test%.") ~= nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.saty",
        prefix .. "document.saty",
        prefix .. "paper.saty",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local saty_files = ctx.glob({ prefix .. "**/*.saty", prefix .. "*.saty" })
    sort_shallow_first(saty_files)
    for _, file in ipairs(saty_files) do
        if not is_test_file(file) then
            return file
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.saty",
        prefix .. "tests/**/*.saty",
        prefix .. "**/*_test.saty",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local saty_files = ctx.glob({ "**/*.saty" })
    local satyg_files = ctx.glob({ "**/*.satyg" })

    if #saty_files == 0 and #satyg_files == 0 then
        error("satysfi plugin: no *.saty or *.satyg files found — add a SATySFi document or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    if entry_source == nil then
        error("satysfi plugin: no *.saty entry document found — add main.saty or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/satysfi/bin"
    local output_name = cfg.output_name or "app.pdf"
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
        has_satyg = #satyg_files > 0,
    }
end

return M
