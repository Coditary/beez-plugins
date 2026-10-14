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

local function grammar_dir(path)
    local dir = path:match("^(.*)/[^/]+$")
    if dir == nil or dir == "" then
        return "."
    end
    return dir
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
        prefix .. "/grammar.js",
        prefix .. "/**/grammar.js",
    })

    sort_shallow_first(files)

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

    local test_dirs = ctx.glob({
        prefix .. "/test/corpus/**",
        prefix .. "/tests/corpus/**",
        prefix .. "/**/test/corpus/**",
    })

    return #test_dirs > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local markers = ctx.glob({ "grammar.js", "**/grammar.js", "bindings/node/binding.gyp" })

    if entry_source == nil and #markers == 0 then
        error("tree-sitter plugin: no grammar.js or bindings/node/binding.gyp found — add grammar sources or set entry_source in configure()")
    end

    local grammar_root = root
    if entry_source ~= nil then
        grammar_root = grammar_dir(entry_source)
    end

    local bin_dir = cfg.bin_dir or "build/tree-sitter/bin"
    local output_name = cfg.output_name or "parser.c"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, grammar_root)
    end

    return {
        project_root = root,
        grammar_root = grammar_root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
