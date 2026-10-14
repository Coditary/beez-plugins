local M = {}

local MARKER_PATTERNS = {
    "CMakeLists.txt",
    "**/CMakeLists.txt",
    "Makefile",
    "**/Makefile",
    "**/*.f",
    "**/*.f90",
    "**/*.f95",
}

local SOURCE_PATTERNS = {
    "**/*.f",
    "**/*.f90",
    "**/*.f95",
}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function strip_extension(path)
    return path:gsub("%.[^%.]+$", "")
end

function M.has_markers(ctx)
    return #ctx.glob(MARKER_PATTERNS) > 0
end

function M.find_project_root(ctx)
    local makefiles = ctx.glob({ "Makefile", "**/Makefile" })
    if #makefiles > 0 then
        table.sort(makefiles)
        local path = makefiles[1]
        local dir = path:match("^(.*)/[^/]+$")
        return dir or "."
    end

    local cmake = ctx.glob({ "CMakeLists.txt", "**/CMakeLists.txt" })
    if #cmake > 0 then
        table.sort(cmake)
        local path = cmake[1]
        local dir = path:match("^(.*)/[^/]+$")
        return dir or "."
    end

    local sources = ctx.glob(SOURCE_PATTERNS)
    if #sources > 0 then
        table.sort(sources)
        local path = sources[1]
        local dir = path:match("^(.*)/[^/]+$")
        return dir or "."
    end

    return nil
end

function M.find_build_system(ctx, root)
    local prefix = ""
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    if #ctx.glob({ prefix .. "Makefile" }) > 0 then
        return "makefile"
    end

    if #ctx.glob({ prefix .. "CMakeLists.txt" }) > 0 then
        return "cmake"
    end

    return "direct"
end

function M.find_sources(ctx, root)
    local prefix = ""
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local patterns = {}
    for _, pattern in ipairs(SOURCE_PATTERNS) do
        patterns[#patterns + 1] = prefix .. pattern
    end

    local sources = ctx.glob(patterns)
    table.sort(sources)
    return sources
end

function M.resolve_build_targets(ctx, root, bin_dir, output_name)
    local build_system = M.find_build_system(ctx, root)
    local sources = M.find_sources(ctx, root)

    if build_system == "makefile" then
        return {
            build_system = "makefile",
            sources = sources,
            targets = {
                {
                    name = output_name,
                    output = bin_dir .. "/" .. output_name,
                },
            },
        }
    end

    if #sources == 0 then
        error("ifx plugin: no Fortran sources found — add .f/.f90/.f95 files or a Makefile")
    end

    local main_source = sources[1]
    for _, source in ipairs(sources) do
        local name = basename(source):lower()
        if name == "main.f90" or name == "main.f" or name == "main.f95" then
            main_source = source
            break
        end
    end

    local target_name = output_name
    if main_source ~= sources[1] then
        target_name = basename(strip_extension(main_source))
    end

    return {
        build_system = "direct",
        sources = sources,
        targets = {
            {
                name = target_name,
                output = bin_dir .. "/" .. target_name,
                sources = sources,
            },
        },
    }
end

function M.resolve(ctx, cfg)
    if not M.has_markers(ctx) then
        error("ifx plugin: no Fortran project markers found — add CMakeLists.txt, Makefile, or .f/.f90/.f95 sources")
    end

    local root = cfg.project_root or M.find_project_root(ctx)
    if root == nil then
        error("ifx plugin: could not determine project root")
    end

    local bin_dir = cfg.bin_dir or "build/ifx/bin"
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    local detected
    if targets == nil then
        detected = M.resolve_build_targets(ctx, root, bin_dir, output_name)
    else
        detected = {
            build_system = cfg.build_system or "direct",
            sources = cfg.sources or M.find_sources(ctx, root),
            targets = targets,
        }
    end

    return {
        project_root = root,
        build_system = detected.build_system,
        sources = detected.sources,
        targets = detected.targets,
        bin_dir = bin_dir,
        primary_output = detected.targets[1].output,
    }
end

return M
