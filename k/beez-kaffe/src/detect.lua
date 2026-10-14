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

    return relative:gsub("%.java$", ""):gsub("/", ".")
end

function M.resolve_test_classes(test_sources, source_root)
    local classes = {}

    for _, path in ipairs(test_sources) do
        classes[#classes + 1] = M.class_name_from_source(path, source_root)
    end

    return classes
end

function M.find_main_class(main_sources, source_root)
    for _, path in ipairs(main_sources) do
        local name = path:match("([^/]+)%.java$")
        if name == "Main" or name == "Application" or name == "App" then
            return M.class_name_from_source(path, source_root)
        end
    end

    if #main_sources == 1 then
        return M.class_name_from_source(main_sources[1], source_root)
    end

    return nil
end

function M.resolve(ctx, cfg)
    local sources = cfg.source_files or M.find_java_sources(ctx)
    if #sources == 0 then
        error("kaffe plugin: no .java sources found — add Java sources or set source_files in configure()")
    end

    local source_root = cfg.source_root or M.resolve_source_root(sources)
    local main_sources, test_sources = M.split_sources(sources)

    if #main_sources == 0 then
        main_sources = sources
        test_sources = {}
    end

    local classes_dir = cfg.classes_dir or "build/kaffe/classes"
    local jar_path = cfg.jar_path or "build/kaffe/app.jar"
    local bin_dir = cfg.bin_dir or "build/kaffe/bin"
    local test_classes = M.resolve_test_classes(test_sources, source_root)
    local main_class = cfg.main_class or M.find_main_class(main_sources, source_root)

    return {
        source_root = source_root,
        main_sources = main_sources,
        test_sources = test_sources,
        test_classes = test_classes,
        main_class = main_class,
        classes_dir = classes_dir,
        jar_path = jar_path,
        bin_dir = bin_dir,
        primary_output = jar_path,
    }
end

return M
