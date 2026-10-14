local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

function M.find_project_marker(ctx)
    local markers = ctx.glob({
        "pom.xml",
        "**/pom.xml",
        "build.gradle",
        "**/build.gradle",
        "build.gradle.kts",
        "**/build.gradle.kts",
    })

    if #markers == 0 then
        return nil
    end

    table.sort(markers, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return markers[1]
end

function M.detect_build_tool(marker_path)
    local name = basename(marker_path)
    if name == "pom.xml" then
        return "maven"
    end
    if name == "build.gradle" or name == "build.gradle.kts" then
        return "gradle"
    end
    error("graalvm plugin: unsupported project marker: " .. tostring(marker_path))
end

function M.project_root(marker_path)
    return dirname(marker_path)
end

function M.has_gradle_wrapper(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local wrappers = ctx.glob({ prefix .. "gradlew", prefix .. "gradlew.bat" })
    return #wrappers > 0
end

function M.resolve_output_name(cfg)
    if cfg.output_name ~= nil and cfg.output_name ~= "" then
        return cfg.output_name
    end

    return "app"
end

function M.resolve(ctx, cfg)
    local marker = cfg.project_marker or M.find_project_marker(ctx)
    if marker == nil then
        error(
            "graalvm plugin: no pom.xml or build.gradle found — "
                .. "add a Java project or set project_marker in configure()"
        )
    end

    local root = cfg.project_root or M.project_root(marker)
    local build_tool = cfg.build_tool or M.detect_build_tool(marker)
    local bin_dir = cfg.bin_dir or "build/graalvm/bin"
    local output_name = M.resolve_output_name(cfg)
    local primary_output = bin_dir .. "/" .. output_name

    return {
        project_marker = marker,
        project_root = root,
        build_tool = build_tool,
        use_gradle_wrapper = cfg.use_gradle_wrapper,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
