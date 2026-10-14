local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function source_root_prefix(root)
    if root == "." or root == "" then
        return ""
    end
    return root .. "/"
end

function M.find_build_system(ctx)
    local poms = ctx.glob({ "pom.xml", "**/pom.xml" })
    if #poms > 0 then
        table.sort(poms)
        local pom = poms[1]
        return "maven", dirname(pom), pom
    end

    local gradle_kts = ctx.glob({ "build.gradle.kts", "**/build.gradle.kts" })
    if #gradle_kts > 0 then
        table.sort(gradle_kts)
        local file = gradle_kts[1]
        return "gradle", dirname(file), file
    end

    local gradle = ctx.glob({ "build.gradle", "**/build.gradle" })
    if #gradle > 0 then
        table.sort(gradle)
        local file = gradle[1]
        return "gradle", dirname(file), file
    end

    local java_files = ctx.glob({ "**/*.java" })
    if #java_files > 0 then
        return "plain", ".", nil
    end

    return nil, nil, nil
end

function M.find_sources(ctx, root)
    local prefix = source_root_prefix(root)
    local standard = ctx.glob({
        prefix .. "src/main/java/**/*.java",
    })

    if #standard > 0 then
        table.sort(standard)
        return standard
    end

    local sources = ctx.glob({ prefix .. "**/*.java" })
    table.sort(sources)
    return sources
end

function M.class_name_from_path(root, java_path)
    local relative = java_path
    local prefix = source_root_prefix(root)

    if prefix ~= "" and relative:sub(1, #prefix) == prefix then
        relative = relative:sub(#prefix + 1)
    end

    local marker = "src/main/java/"
    local marker_at = relative:find(marker, 1, true)
    if marker_at ~= nil then
        relative = relative:sub(marker_at + #marker)
    else
        local src_marker = "src/"
        local src_at = relative:find(src_marker, 1, true)
        if src_at ~= nil then
            relative = relative:sub(src_at + #src_marker)
        end
    end

    if relative:sub(-5) == ".java" then
        relative = relative:sub(1, -6)
    end

    return relative:gsub("/", ".")
end

function M.find_main_class(ctx, root, sources)
    local prefix = source_root_prefix(root)
    local preferred = ctx.glob({
        prefix .. "src/main/java/**/Main.java",
        prefix .. "src/main/java/**/Application.java",
        prefix .. "src/main/java/**/App.java",
        prefix .. "Main.java",
        prefix .. "Application.java",
        prefix .. "App.java",
    })

    if #preferred > 0 then
        table.sort(preferred)
        return M.class_name_from_path(root, preferred[1])
    end

    if sources ~= nil and #sources == 1 then
        return M.class_name_from_path(root, sources[1])
    end

    for _, source in ipairs(sources or {}) do
        local name = basename(source)
        if name:sub(-5) == ".java" then
            name = name:sub(1, -6)
        end
        if name == "Main" or name == "Application" or name == "App" then
            return M.class_name_from_path(root, source)
        end
    end

    if sources ~= nil and #sources > 0 then
        return M.class_name_from_path(root, sources[1])
    end

    return nil
end

function M.gradle_command(ctx, root)
    local prefix = source_root_prefix(root)
    local wrappers = ctx.glob({
        prefix .. "gradlew",
        "gradlew",
    })

    if #wrappers > 0 then
        return "./gradlew"
    end

    return "gradle"
end

function M.resolve(ctx, cfg)
    local build_system, project_root, manifest = M.find_build_system(ctx)
    if build_system == nil then
        error("jikesrvm plugin: no Java project found — add pom.xml, build.gradle, or .java sources")
    end

    project_root = cfg.project_root or project_root
    local sources = cfg.sources
    if sources == nil then
        sources = M.find_sources(ctx, project_root)
    end

    if #sources == 0 then
        error("jikesrvm plugin: no .java source files found")
    end

    local main_class = cfg.main_class or M.find_main_class(ctx, project_root, sources)
    local classes_dir = cfg.classes_dir or "build/jikesrvm/classes"
    local bin_dir = cfg.bin_dir or "build/jikesrvm/bin"

    return {
        build_system = build_system,
        project_root = project_root,
        manifest = manifest,
        sources = sources,
        main_class = main_class,
        classes_dir = classes_dir,
        bin_dir = bin_dir,
        gradle_command = M.gradle_command(ctx, project_root),
        primary_output = classes_dir,
    }
end

return M
