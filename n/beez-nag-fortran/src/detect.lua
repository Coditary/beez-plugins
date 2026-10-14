local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function stem(path)
    return basename(path):match("^(.+)%.[^%.]+$") or basename(path)
end

local function prefix_for_root(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function relative_to_root(path, root)
    if root == "." or root == "" then
        return path
    end
    local prefix = root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end
    return path
end

function M.find_project_marker(ctx)
    local markers = ctx.glob({
        "CMakeLists.txt",
        "Makefile",
        "makefile",
        "GNUmakefile",
        "*.f",
        "*.f90",
        "*.f95",
        "**/CMakeLists.txt",
        "**/Makefile",
        "**/*.f",
        "**/*.f90",
        "**/*.f95",
    })

    if #markers == 0 then
        return nil
    end

    local priority = {
        ["CMakeLists.txt"] = 1,
        ["Makefile"] = 2,
        ["makefile"] = 2,
        ["GNUmakefile"] = 2,
    }

    table.sort(markers, function(a, b)
        local base_a = basename(a)
        local base_b = basename(b)
        local pri_a = priority[base_a] or 10
        local pri_b = priority[base_b] or 10
        if pri_a ~= pri_b then
            return pri_a < pri_b
        end
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return markers[1]
end

function M.project_root(marker_path)
    return dirname(marker_path)
end

function M.detect_build_system(ctx, root)
    local prefix = prefix_for_root(root)

    local cmake = ctx.glob({ prefix .. "CMakeLists.txt" })
    if #cmake > 0 then
        return "cmake", relative_to_root(cmake[1], root)
    end

    local makefiles = ctx.glob({
        prefix .. "Makefile",
        prefix .. "makefile",
        prefix .. "GNUmakefile",
    })
    if #makefiles > 0 then
        return "makefile", relative_to_root(makefiles[1], root)
    end

    return "sources", nil
end

function M.resolve_build_targets(ctx, root)
    local prefix = prefix_for_root(root)
    local targets = {}
    local seen = {}

    local function add_target(source_path)
        if seen[source_path] then
            return
        end
        seen[source_path] = true

        local name = stem(source_path)
        targets[#targets + 1] = {
            source = relative_to_root(source_path, root),
            name = name,
            output = nil,
        }
    end

    for _, pattern in ipairs({
        prefix .. "main.f90",
        prefix .. "main.f95",
        prefix .. "main.f",
        prefix .. "program.f90",
        prefix .. "app.f90",
        prefix .. "src/main.f90",
        prefix .. "src/main.f95",
        prefix .. "src/main.f",
        prefix .. "**/main.f90",
        prefix .. "**/main.f95",
        prefix .. "**/main.f",
    }) do
        for _, path in ipairs(ctx.glob({ pattern })) do
            add_target(path)
        end
    end

    if #targets == 0 then
        for _, ext in ipairs({ "f90", "f95", "f" }) do
            for _, path in ipairs(ctx.glob({ prefix .. "*." .. ext })) do
                add_target(path)
            end
            if #targets > 0 then
                break
            end
        end
    end

    if #targets == 0 then
        for _, ext in ipairs({ "f90", "f95", "f" }) do
            for _, path in ipairs(ctx.glob({ prefix .. "**/*." .. ext })) do
                add_target(path)
                break
            end
            if #targets > 0 then
                break
            end
        end
    end

    if #targets == 0 then
        targets[#targets + 1] = {
            source = "main.f90",
            name = "app",
            output = nil,
        }
    end

    return targets
end

function M.resolve_test_runner(ctx, root)
    local prefix = prefix_for_root(root)
    local candidates = ctx.glob({
        prefix .. "tests/runtests.f90",
        prefix .. "tests/runtests.f95",
        prefix .. "tests/testrunner.f90",
        prefix .. "test/runtests.f90",
        prefix .. "test/testrunner.f90",
        prefix .. "**/runtests.f90",
        prefix .. "**/testrunner.f90",
    })

    if #candidates == 0 then
        return nil
    end

    table.sort(candidates)
    return relative_to_root(candidates[1], root)
end

function M.resolve(ctx, cfg)
    local marker = cfg.project_marker or M.find_project_marker(ctx)
    if marker == nil then
        error("nag-fortran plugin: no Fortran project found — add CMakeLists.txt, Makefile, or *.f/*.f90/*.f95 sources")
    end

    local root = cfg.project_root or M.project_root(marker)
    local build_system, build_file = M.detect_build_system(ctx, root)
    local targets = cfg.targets

    if build_system == "sources" and targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/nag/bin"

    if targets ~= nil then
        for _, target in ipairs(targets) do
            if target.output == nil then
                target.output = bin_dir .. "/" .. (target.name or output_name)
            end
        end
    end

    local test_runner = cfg.test_runner or M.resolve_test_runner(ctx, root)

    return {
        project_marker = marker,
        project_root = root,
        build_system = build_system,
        build_file = build_file,
        targets = targets,
        bin_dir = bin_dir,
        cmake_dir = cfg.cmake_dir or "build/nag/cmake",
        primary_output = targets and targets[1].output or (bin_dir .. "/" .. output_name),
        primary_source = targets and targets[1].source or nil,
        test_runner = test_runner,
    }
end

return M
