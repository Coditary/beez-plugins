local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function package_name_from_cabal(cabal_path)
    local name = basename(cabal_path)
    return name:match("^(.+)%.cabal$") or "app"
end

local function parse_cabal_executables(cabal_path)
    local names = {}
    local file = io.open(cabal_path, "r")
    if file == nil then
        return names
    end

    local content = file:read("*a")
    file:close()

    for line in content:gmatch("[^\r\n]+") do
        local exe = line:match("^executable%s+(%S+)")
        if exe then
            names[#names + 1] = exe
        end
    end

    return names
end

function M.find_cabal_file(ctx)
    local files = ctx.glob({ "*.cabal", "**/*.cabal" })
    if #files == 0 then
        return nil
    end

    table.sort(files, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return files[1]
end

function M.find_main_hs(ctx, root, exe_name)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local candidates = {}

    if exe_name ~= nil and exe_name ~= "app" then
        candidates[#candidates + 1] = prefix .. exe_name .. "/Main.hs"
        candidates[#candidates + 1] = prefix .. "app/" .. exe_name .. "/Main.hs"
    end

    candidates[#candidates + 1] = prefix .. "app/Main.hs"
    candidates[#candidates + 1] = prefix .. "src/Main.hs"
    candidates[#candidates + 1] = prefix .. "Main.hs"

    local matches = ctx.glob(candidates)
    if #matches == 0 then
        return nil
    end

    table.sort(matches)
    return matches[1]
end

function M.resolve_build_tool(ctx, cfg)
    if cfg.build_tool ~= nil then
        return cfg.build_tool
    end

    if M.find_cabal_file(ctx) ~= nil then
        return "cabal"
    end

    return "direct"
end

function M.resolve_executables(cabal_path, package_name)
    if cabal_path == nil then
        return { package_name }
    end

    local executables = parse_cabal_executables(cabal_path)
    if #executables == 0 then
        return { package_name }
    end

    return executables
end

function M.resolve_targets(ctx, root, executables, main_hs, bin_dir)
    local targets = {}

    for _, name in ipairs(executables) do
        local source = M.find_main_hs(ctx, root, name)
        if source == nil and main_hs ~= nil and #executables == 1 then
            source = main_hs
        end
        if source ~= nil then
            targets[#targets + 1] = {
                name = name,
                source = source,
                output = bin_dir .. "/" .. name,
            }
        end
    end

    if #targets == 0 and main_hs ~= nil then
        local name = executables[1] or "app"
        targets[#targets + 1] = {
            name = name,
            source = main_hs,
            output = bin_dir .. "/" .. name,
        }
    end

    return targets
end

function M.find_test_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local tests = ctx.glob({
        prefix .. "tests/**/*.hs",
        prefix .. "test/**/*.hs",
        prefix .. "**/*_test.hs",
        prefix .. "**/test_*.hs",
    })

    table.sort(tests)
    return tests
end

function M.resolve(ctx, cfg)
    local build_tool = M.resolve_build_tool(ctx, cfg)
    local cabal_file = cfg.cabal_file or M.find_cabal_file(ctx)

    local project_root = cfg.project_root or "."
    if cabal_file ~= nil then
        project_root = dirname(cabal_file)
    end

    local package_name = cfg.package_name
    if package_name == nil and cabal_file ~= nil then
        package_name = package_name_from_cabal(cabal_file)
    end
    package_name = package_name or "app"

    local executables = cfg.executables
    if executables == nil then
        executables = M.resolve_executables(cabal_file, package_name)
    end

    local main_hs = cfg.main_hs or M.find_main_hs(ctx, project_root, executables[1])
    local bin_dir = cfg.bin_dir or "build/yhc/bin"

    local targets = cfg.targets
    if targets == nil then
        targets = M.resolve_targets(ctx, project_root, executables, main_hs, bin_dir)
    end

    if #targets == 0 then
        error("yhc plugin: no Haskell entry point found — add Main.hs, *.cabal, or set main_hs in configure()")
    end

    local test_sources = cfg.test_sources
    if test_sources == nil then
        test_sources = M.find_test_sources(ctx, project_root)
    end

    return {
        build_tool = build_tool,
        cabal_file = cabal_file,
        project_root = project_root,
        package_name = package_name,
        executables = executables,
        main_hs = main_hs,
        targets = targets,
        test_sources = test_sources,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        artifact_globs = {
            bin_dir .. "/**",
        },
    }
end

return M
