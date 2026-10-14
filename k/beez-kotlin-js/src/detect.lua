local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function depth(path)
    return select(2, path:gsub("/", ""))
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = depth(a)
        local depth_b = depth(b)
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

function M.find_gradle_build(ctx)
    local kts = ctx.glob({ "build.gradle.kts", "**/build.gradle.kts" })
    if #kts > 0 then
        sort_shallow_first(kts)
        return kts[1], "kts"
    end

    local groovy = ctx.glob({ "build.gradle", "**/build.gradle" })
    if #groovy > 0 then
        sort_shallow_first(groovy)
        return groovy[1], "groovy"
    end

    return nil, nil
end

function M.find_gradlew(ctx, project_root)
    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    local wrappers = ctx.glob({ prefix .. "gradlew", prefix .. "gradlew.bat" })
    for _, wrapper in ipairs(wrappers) do
        if wrapper:match("gradlew$") then
            return wrapper
        end
    end

    return nil
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    local roots = {
        prefix .. "src/jsMain/kotlin",
        prefix .. "src/main/kotlin",
        prefix .. "src",
        prefix,
    }

    local sources = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({ root .. "/**/*.kt", root .. "/*.kt" })
        for _, file in ipairs(files) do
            if not seen[file] then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
        if #sources > 0 then
            break
        end
    end

    if #sources == 0 then
        local all = ctx.glob({ prefix .. "**/*.kt" })
        for _, file in ipairs(all) do
            if not file:match("/build/") and not file:match("/%.gradle/") then
                sources[#sources + 1] = file
            end
        end
    end

    return sources
end

function M.resolve(ctx, cfg)
    local gradle_build = cfg.gradle_build
    local backend = cfg.backend

    if gradle_build == nil then
        gradle_build = select(1, M.find_gradle_build(ctx))
    end

    if backend == nil then
        backend = gradle_build ~= nil and "gradle" or "kotlinc-js"
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if gradle_build ~= nil then
            project_root = dirname(gradle_build)
        else
            project_root = "."
        end
    end

    local gradlew = cfg.gradlew or M.find_gradlew(ctx, project_root)
    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_roots(ctx, project_root)
    end

    if backend == "kotlinc-js" and #sources == 0 then
        error("kotlin-js plugin: no Kotlin sources found — add .kt files or a Gradle build")
    end

    if backend == "gradle" and gradle_build == nil then
        error("kotlin-js plugin: Gradle backend selected but no build.gradle(.kts) found")
    end

    local output_name = cfg.output_name or "app"
    local js_dir = cfg.js_dir or "build/kotlin-js/js"
    local bin_dir = cfg.bin_dir or "build/kotlin-js/bin"

    return {
        backend = backend,
        gradle_build = gradle_build,
        gradlew = gradlew,
        project_root = project_root,
        sources = sources,
        js_dir = js_dir,
        bin_dir = bin_dir,
        primary_output = js_dir .. "/" .. output_name .. ".js",
        js_output = js_dir,
    }
end

return M
