local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
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

function M.find_build_sbt(ctx)
    local sbt = ctx.glob({ "build.sbt", "**/build.sbt" })
    if #sbt > 0 then
        sort_shallow_first(sbt)
        return sbt[1]
    end

    local props = ctx.glob({ "project/build.properties", "**/project/build.properties" })
    if #props > 0 then
        sort_shallow_first(props)
        return dirname(props[1]) .. "/build.sbt"
    end

    return nil
end

function M.collect_scala_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
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

    for _, source_root in ipairs(roots) do
        local files = ctx.glob({ source_root .. "/**/*.scala", source_root .. "/*.scala" })
        for _, file in ipairs(files) do
            if not seen[file] and not file:match("/target/") then
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

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/src/test/scala/**/*.scala",
        prefix .. "/test/**/*.scala",
        prefix .. "/**/*Test.scala",
        prefix .. "/**/*Spec.scala",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local build_sbt = cfg.build_sbt
    if build_sbt == nil then
        build_sbt = M.find_build_sbt(ctx)
    end

    local scala_files = ctx.glob({ "**/*.scala" })
    if build_sbt == nil and #scala_files == 0 then
        error("chisel plugin: no build.sbt or *.scala files found — add a Chisel project or set build_sbt in configure()")
    end

    local root = cfg.project_root
    if root == nil then
        if build_sbt ~= nil then
            root = dirname(build_sbt)
        else
            root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.collect_scala_sources(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local classes_dir = cfg.classes_dir or "build/chisel/classes"
    local bin_dir = cfg.bin_dir or "build/chisel/bin"
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        build_sbt = build_sbt,
        has_build_sbt = build_sbt ~= nil,
        project_root = root,
        sources = sources,
        classes_dir = classes_dir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = bin_dir .. "/" .. output_name .. ".jar",
        classes_output = classes_dir,
        has_tests = has_tests,
    }
end

return M
