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

function M.find_project_marker(ctx)
    local markers = ctx.glob({
        "CMakeLists.txt",
        "Makefile",
        "**/*.f90",
        "**/*.f95",
        "**/*.f",
    })

    if #markers == 0 then
        return nil
    end

    sort_shallow_first(markers)
    return markers[1]
end

function M.project_root(marker_path)
    return dirname(marker_path)
end

function M.detect_build_system(ctx, root)
    local prefix = prefix_for_root(root)

    local cmake = ctx.glob({ prefix .. "CMakeLists.txt", "CMakeLists.txt" })
    if #cmake > 0 then
        sort_shallow_first(cmake)
        return "cmake", cmake[1]
    end

    local makefile = ctx.glob({
        prefix .. "Makefile",
        "Makefile",
        prefix .. "makefile",
    })
    if #makefile > 0 then
        sort_shallow_first(makefile)
        return "make", makefile[1]
    end

    return "direct", nil
end

function M.resolve_build_targets(ctx, root, build_system)
    if build_system == "cmake" then
        return {
            {
                build_system = "cmake",
                name = "app",
                output = nil,
            },
        }
    end

    if build_system == "make" then
        return {
            {
                build_system = "make",
                name = "app",
                output = nil,
            },
        }
    end

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
            build_system = "direct",
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
        prefix .. "program.f95",
        prefix .. "program.f",
    }) do
        for _, path in ipairs(ctx.glob({ pattern })) do
            add_target(path)
        end
    end

    if #targets == 0 then
        for _, pattern in ipairs({
            prefix .. "*.f90",
            prefix .. "*.f95",
            prefix .. "*.f",
            prefix .. "src/*.f90",
            prefix .. "src/*.f95",
            prefix .. "src/*.f",
        }) do
            for _, path in ipairs(ctx.glob({ pattern })) do
                add_target(path)
            end
        end
    end

    if #targets == 0 then
        targets[#targets + 1] = {
            build_system = "direct",
            source = prefix .. "main.f90",
            name = "app",
            output = nil,
        }
    end

    return targets
end

function M.resolve_test_runner(ctx, root, build_system)
    if build_system == "cmake" then
        return { kind = "ctest" }
    end

    local prefix = prefix_for_root(root)
    local candidates = ctx.glob({
        prefix .. "tests/run_tests.f90",
        prefix .. "tests/run_tests.f95",
        prefix .. "tests/run_tests.f",
        prefix .. "test/run_tests.f90",
        prefix .. "test/run_tests.f95",
        prefix .. "test/run_tests.f",
        prefix .. "**/run_tests.f90",
        prefix .. "**/run_tests.f95",
        prefix .. "**/run_tests.f",
    })

    if #candidates == 0 then
        return nil
    end

    sort_shallow_first(candidates)
    return {
        kind = "program",
        source = relative_to_root(candidates[1], root),
    }
end

function M.resolve(ctx, cfg)
    local marker = cfg.project_marker or M.find_project_marker(ctx)
    if marker == nil then
        error("flang plugin: no Fortran project found — add CMakeLists.txt, Makefile, or *.f/*.f90/*.f95 sources")
    end

    local root = cfg.project_root or M.project_root(marker)
    local build_system, build_marker = M.detect_build_system(ctx, root)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, build_system)
    end

    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/flang/bin"

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
        target.build_system = target.build_system or build_system
    end

    local test_runner = cfg.test_runner
    if test_runner == nil then
        test_runner = M.resolve_test_runner(ctx, root, build_system)
    end

    return {
        project_marker = marker,
        project_root = root,
        build_system = build_system,
        build_marker = build_marker,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        test_runner = test_runner,
    }
end

return M
