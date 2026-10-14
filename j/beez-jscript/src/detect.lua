local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
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

local function is_test_file(path)
    return path:match("/test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("test_") ~= nil
        or path:match("_test%.") ~= nil
end

local function is_jscript_source(path)
    return path:match("%.jse$") ~= nil or path:match("%.js$") ~= nil
end

function M.find_sources(ctx)
    local sources = {}
    local seen = {}

    for _, pattern in ipairs({ "**/*.js", "**/*.jse" }) do
        for _, path in ipairs(ctx.glob({ pattern })) do
            if not seen[path] and is_jscript_source(path) then
                seen[path] = true
                sources[#sources + 1] = path
            end
        end
    end

    sort_shallow_first(sources)
    return sources
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.js",
        prefix .. "index.js",
        prefix .. "app.js",
        prefix .. "main.jse",
        prefix .. "index.jse",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local all = M.find_sources(ctx)
    for _, file in ipairs(all) do
        if not is_test_file(file) then
            return file
        end
    end

    if #all > 0 then
        return all[1]
    end

    return nil
end

function M.resolve_compile_targets(ctx, root)
    local targets = {}
    local seen = {}

    local matches = M.find_sources(ctx)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_file(source) then
            seen[source] = true
            local name = basename(source):match("^(.+)%.[^%.]+$") or basename(source)
            targets[#targets + 1] = {
                source = source,
                name = name,
            }
        end
    end

    if #targets == 0 then
        error("jscript plugin: no .js or .jse source files found — add JScript scripts or set project_root in configure()")
    end

    return targets
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "test/**/*.js",
        prefix .. "tests/**/*.js",
        prefix .. "test/**/*.jse",
        prefix .. "tests/**/*.jse",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local jscript_files = M.find_sources(ctx)

    if #jscript_files == 0 then
        error("jscript plugin: no *.js or *.jse files found — add JScript scripts or set entry_source in configure()")
    end

    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local targets = cfg.targets
    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/jscript/bin"
    local output_name = cfg.output_name or "app.js"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        targets = targets,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        primary_source = entry_source or targets[1].source,
        has_tests = has_tests,
    }
end

return M
