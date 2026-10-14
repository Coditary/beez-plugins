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

local function is_test_file(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("test_") ~= nil
        or path:match("_test%.") ~= nil
end

local function read_header(path, max_lines)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return ""
    end

    local lines = {}
    for _ = 1, max_lines or 40 do
        local line = file:read("*l")
        if line == nil then
            break
        end
        lines[#lines + 1] = line
    end

    file:close()
    return table.concat(lines, "\n")
end

function M.is_remarkjs_file(path)
    local header = read_header(path)
    return header:match("class:%s*remark") ~= nil
        or header:match("remark%-js") ~= nil
        or header:match("count:%s*true") ~= nil
        or header:match("name:%s*front%-page") ~= nil
        or header:match("template:%s*remark") ~= nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*.md",
        prefix .. "/*.md",
    })

    sort_shallow_first(files)

    for _, file in ipairs(files) do
        if not is_test_file(file) and M.is_remarkjs_file(file) then
            return file
        end
    end

    for _, file in ipairs(files) do
        if not is_test_file(file) then
            return file
        end
    end

    if #files > 0 then
        return files[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/test/**/*.md",
        prefix .. "/tests/**/*.md",
        prefix .. "/**/test_*.md",
        prefix .. "/**/*_test.md",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local md_files = ctx.glob({ "**/*.md" })
    local remark_files = {}

    for _, file in ipairs(md_files) do
        if M.is_remarkjs_file(file) then
            remark_files[#remark_files + 1] = file
        end
    end

    if entry_source == nil and #remark_files == 0 then
        error("remarkjs plugin: no remark.js *.md files found — add remark frontmatter or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/remarkjs/bin"
    local output_name = cfg.output_name or "app.html"
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
