local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function stem(path)
    local name = basename(path)
    return name:match("^(.+)%.[^%.]+$") or name
end

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

function M.find_elements(ctx)
    local projects = ctx.glob({ "*.elements", "**/*.elements" })
    if #projects == 0 then
        return nil
    end

    sort_shallow_first(projects)
    return projects[1]
end

function M.find_oxygene(ctx)
    local projects = ctx.glob({ "*.oxygene", "**/*.oxygene" })
    if #projects == 0 then
        return nil
    end

    sort_shallow_first(projects)
    return projects[1]
end

function M.find_test_elements(ctx)
    local projects = ctx.glob({
        "*Test.elements",
        "**/*Test.elements",
        "*Tests.elements",
        "**/*Tests.elements",
    })
    if #projects == 0 then
        return nil
    end

    sort_shallow_first(projects)
    return projects[1]
end

function M.find_source_files(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    return ctx.glob({
        prefix .. "**/*.pas",
        prefix .. "**/*.oxygene",
    })
end

function M.detect_toolchain(ctx, cfg)
    if cfg.toolchain ~= nil and cfg.toolchain ~= "" then
        return cfg.toolchain
    end

    if M.find_elements(ctx) ~= nil or M.find_oxygene(ctx) ~= nil then
        return "msbuild"
    end

    local sources = ctx.glob({ "**/*.pas", "**/*.oxygene" })
    if #sources > 0 then
        return "elements"
    end

    error("oxygene plugin: no *.elements, *.oxygene, or **/*.pas found — add an Oxygene project or set project_file in configure()")
end

function M.resolve_project(ctx, cfg)
    local elements = cfg.elements or cfg.project_file or M.find_elements(ctx)
    if elements ~= nil then
        return {
            project_file = elements,
            project_root = cfg.project_root or dirname(elements),
            project_kind = "elements",
            output_name = cfg.output_name or stem(elements),
        }
    end

    local oxygene = cfg.oxygene or M.find_oxygene(ctx)
    if oxygene ~= nil then
        return {
            project_file = oxygene,
            project_root = cfg.project_root or dirname(oxygene),
            project_kind = "oxygene",
            output_name = cfg.output_name or stem(oxygene),
        }
    end

    local root = cfg.project_root or "."
    local sources = cfg.source_files
    if sources == nil then
        sources = M.find_source_files(ctx, root)
    end

    if #sources == 0 then
        error("oxygene plugin: no *.elements, *.oxygene, or **/*.pas found — add an Oxygene project or set source_files in configure()")
    end

    return {
        project_file = nil,
        project_root = root,
        project_kind = "sources",
        source_files = sources,
        output_name = cfg.output_name or "app",
    }
end

function M.resolve(ctx, cfg)
    local toolchain = M.detect_toolchain(ctx, cfg)
    local project = M.resolve_project(ctx, cfg)
    local bin_dir = cfg.bin_dir or "build/oxygene/bin"
    local obj_dir = cfg.obj_dir or "build/oxygene/obj"
    local build_dir = cfg.build_dir or "build/oxygene"
    local output_name = project.output_name
    local test_elements = cfg.test_elements or M.find_test_elements(ctx)

    return {
        toolchain = toolchain,
        project_file = project.project_file,
        project_root = project.project_root,
        project_kind = project.project_kind,
        source_files = project.source_files,
        build_dir = build_dir,
        bin_dir = bin_dir,
        obj_dir = obj_dir,
        primary_output = bin_dir,
        output_name = output_name,
        test_elements = test_elements,
    }
end

return M
