local M = {}

function M.find_java_sources(ctx)
    local sources = ctx.glob({ "**/*.java" })
    table.sort(sources)
    return sources
end

function M.is_test_source(path)
    if path:match("Test%.java$") then
        return true
    end
    return path:match("^test/") ~= nil or path:match("/test/") ~= nil
end

function M.resolve_source_root(sources)
    for _, path in ipairs(sources) do
        if path:match("^src/") or path:match("/src/") then
            return "src"
        end
    end

    return "."
end

function M.split_sources(sources)
    local main_sources = {}
    local test_sources = {}

    for _, path in ipairs(sources) do
        if M.is_test_source(path) then
            test_sources[#test_sources + 1] = path
        else
            main_sources[#main_sources + 1] = path
        end
    end

    return main_sources, test_sources
end

function M.class_name_from_source(path, source_root)
    local relative = path
    if source_root ~= "." and source_root ~= "" then
        local prefix = source_root .. "/"
        if path:sub(1, #prefix) == prefix then
            relative = path:sub(#prefix + 1)
        end
    end

    local class_path = relative:gsub("%.java$", ""):gsub("/", ".")
    return class_path
end

function M.resolve_test_classes(test_sources, source_root)
    local classes = {}

    for _, path in ipairs(test_sources) do
        classes[#classes + 1] = M.class_name_from_source(path, source_root)
    end

    return classes
end

function M.resolve(ctx, cfg)
    local sources = cfg.source_files or M.find_java_sources(ctx)
    if #sources == 0 then
        error("jikes plugin: no .java sources found — add Java sources or set source_files in configure()")
    end

    local source_root = cfg.source_root or M.resolve_source_root(sources)
    local main_sources, test_sources = M.split_sources(sources)

    if #main_sources == 0 then
        main_sources = sources
        test_sources = {}
    end

    local classes_dir = cfg.classes_dir or "build/jikes/classes"
    local jar_path = cfg.jar_path or "build/jikes/app.jar"
    local test_classes = M.resolve_test_classes(test_sources, source_root)

    return {
        source_root = source_root,
        main_sources = main_sources,
        test_sources = test_sources,
        test_classes = test_classes,
        classes_dir = classes_dir,
        jar_path = jar_path,
        primary_output = jar_path,
    }
end

return M
