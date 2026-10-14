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

local function read_file(path, max_bytes)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return ""
    end

    local content = file:read(max_bytes or 8192)
    file:close()
    return content or ""
end

function M.is_skribilo_file(path)
    local content = read_file(path)
    return content:match("%(%s*use%s+skribilo%s*%)") ~= nil
        or content:match("%(%s*require%s+%(?[\"']skribilo") ~= nil
        or content:match("import%s+skribilo") ~= nil
        or path:match("%.skr$") ~= nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.skr",
        prefix .. "document.skr",
        prefix .. "paper.skr",
        prefix .. "main.ss",
        prefix .. "document.ss",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, file in ipairs(matches) do
            if M.is_skribilo_file(file) then
                return file
            end
        end
    end

    local skr_files = ctx.glob({ prefix .. "**/*.skr", prefix .. "*.skr" })
    sort_shallow_first(skr_files)
    for _, file in ipairs(skr_files) do
        if not is_test_file(file) then
            return file
        end
    end

    local ss_files = ctx.glob({ prefix .. "**/*.ss", prefix .. "*.ss" })
    sort_shallow_first(ss_files)
    for _, file in ipairs(ss_files) do
        if not is_test_file(file) and M.is_skribilo_file(file) then
            return file
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.skr",
        prefix .. "tests/**/*.skr",
        prefix .. "test/**/*.ss",
        prefix .. "tests/**/*.ss",
        prefix .. "**/*_test.skr",
        prefix .. "**/*_test.ss",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local skr_files = ctx.glob({ "**/*.skr" })
    local ss_files = ctx.glob({ "**/*.ss" })
    local skribilo_files = {}

    for _, file in ipairs(skr_files) do
        skribilo_files[#skribilo_files + 1] = file
    end

    for _, file in ipairs(ss_files) do
        if M.is_skribilo_file(file) then
            skribilo_files[#skribilo_files + 1] = file
        end
    end

    if #skr_files == 0 and #ss_files == 0 then
        error("skribilo plugin: no *.skr or *.ss files found — add a Skribilo document or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    if entry_source == nil then
        error("skribilo plugin: no Skribilo entry document found — add main.skr or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/skribilo/bin"
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
    }
end

return M
