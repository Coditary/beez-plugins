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

function M.find_sbt_build(ctx)
    local sbt = ctx.glob({ "build.sbt", "**/build.sbt" })
    if #sbt > 0 then
        sort_shallow_first(sbt)
        return sbt[1], "sbt"
    end

    local props = ctx.glob({ "project/build.properties", "**/project/build.properties" })
    if #props > 0 then
        sort_shallow_first(props)
        return dirname(props[1]) .. "/build.sbt", "sbt"
    end

    return nil, nil
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    local roots = {
        prefix .. "src/main/scala",
        prefix .. "src",
        prefix,
    }

    local sources = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({ root .. "/**/*.scala", root .. "/*.scala" })
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
        local all = ctx.glob({ prefix .. "**/*.scala" })
        for _, file in ipairs(all) do
            if not file:match("/target/") and not file:match("/%.sbt/") and not file:match("/project/") then
                sources[#sources + 1] = file
            end
        end
    end

    return sources
end

function M.resolve(ctx, cfg)
    local sbt_build = cfg.sbt_build
    local backend = cfg.backend

    if sbt_build == nil then
        sbt_build = select(1, M.find_sbt_build(ctx))
    end

    if backend == nil then
        backend = sbt_build ~= nil and "sbt" or "scalac"
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if sbt_build ~= nil then
            project_root = dirname(sbt_build)
        else
            project_root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_roots(ctx, project_root)
    end

    if backend == "scalac" and #sources == 0 then
        error("dotty plugin: no Scala sources found — add .scala files or an sbt build")
    end

    if backend == "sbt" and sbt_build == nil then
        error("dotty plugin: sbt backend selected but no build.sbt / project/build.properties found")
    end

    local output_name = cfg.output_name or "app"
    local classes_dir = cfg.classes_dir or "build/dotty/classes"
    local bin_dir = cfg.bin_dir or "build/dotty/bin"

    return {
        backend = backend,
        sbt_build = sbt_build,
        project_root = project_root,
        sources = sources,
        classes_dir = classes_dir,
        bin_dir = bin_dir,
        primary_output = bin_dir .. "/" .. output_name .. ".jar",
        classes_output = classes_dir,
    }
end

return M
