local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function shallowest(paths)
    if #paths == 0 then
        return nil
    end

    table.sort(paths, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return paths[1]
end

function M.find_manifest(ctx)
    local poms = ctx.glob({ "pom.xml", "**/pom.xml" })
    local pom = shallowest(poms)
    if pom ~= nil then
        return pom, "maven"
    end

    local gradles = ctx.glob({
        "build.gradle",
        "build.gradle.kts",
        "**/build.gradle",
        "**/build.gradle.kts",
    })
    local gradle = shallowest(gradles)
    if gradle ~= nil then
        return gradle, "gradle"
    end

    local java_files = ctx.glob({ "**/*.java" })
    if #java_files > 0 then
        return java_files[1], "plain"
    end

    return nil, nil
end

function M.project_root(manifest_path, project_type)
    if project_type == "plain" then
        return dirname(manifest_path)
    end
    return dirname(manifest_path)
end

function M.resolve_source_roots(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local candidates = {
        prefix .. "src/main/java",
        prefix .. "src",
    }

    local roots = {}
    local seen = {}

    for _, candidate in ipairs(candidates) do
        local matches = ctx.glob({ candidate .. "/**/*.java", candidate .. "/*.java" })
        if #matches > 0 and not seen[candidate] then
            seen[candidate] = true
            roots[#roots + 1] = candidate
        end
    end

    if #roots == 0 then
        roots[#roots + 1] = prefix == "" and "." or root
    end

    return roots
end

function M.resolve_main_class(ctx, root, output_name)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local candidates = ctx.glob({
        prefix .. "src/main/java/**/Main.java",
        prefix .. "src/**/Main.java",
        prefix .. "**/Main.java",
        prefix .. "src/main/java/**/Application.java",
        prefix .. "src/**/Application.java",
    })

    if #candidates > 0 then
        table.sort(candidates)
        local path = candidates[1]
        local relative = path:gsub("^" .. prefix, "")
        relative = relative:gsub("%.java$", "")
        return relative:gsub("/", ".")
    end

    return output_name or "app"
end

function M.resolve(ctx, cfg)
    local manifest = cfg.manifest or cfg.pom_xml or cfg.build_gradle
    local project_type = cfg.project_type

    if manifest == nil or project_type == nil then
        local detected_type
        manifest, detected_type = M.find_manifest(ctx)
        project_type = project_type or detected_type
    end

    if manifest == nil then
        error("ecj plugin: no pom.xml, build.gradle, or .java sources found — add a Java project or set manifest in configure()")
    end

    local root = cfg.project_root or M.project_root(manifest, project_type)
    local source_roots = cfg.source_roots
    if source_roots == nil then
        source_roots = M.resolve_source_roots(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local classes_dir = cfg.classes_dir or "build/ecj/classes"
    local main_class = cfg.main_class or M.resolve_main_class(ctx, root, output_name)

    return {
        manifest = manifest,
        project_type = project_type,
        project_root = root,
        source_roots = source_roots,
        main_class = main_class,
        classes_dir = classes_dir,
        primary_output = classes_dir,
    }
end

return M
