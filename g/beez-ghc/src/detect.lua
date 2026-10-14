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

function M.find_stack_yaml(ctx)
    local files = ctx.glob({ "stack.yaml", "**/stack.yaml" })
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

function M.find_main_hs(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local candidates = ctx.glob({
        prefix .. "app/Main.hs",
        prefix .. "src/Main.hs",
        prefix .. "Main.hs",
    })

    if #candidates == 0 then
        return nil
    end

    table.sort(candidates)
    return candidates[1]
end

function M.resolve_build_tool(ctx, cfg)
    if cfg.build_tool ~= nil then
        return cfg.build_tool
    end

    if M.find_stack_yaml(ctx) ~= nil then
        return "stack"
    end

    if M.find_cabal_file(ctx) ~= nil then
        return "cabal"
    end

    return "ghc"
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

function M.resolve(ctx, cfg)
    local build_tool = M.resolve_build_tool(ctx, cfg)
    local stack_yaml = cfg.stack_yaml or M.find_stack_yaml(ctx)
    local cabal_file = cfg.cabal_file or M.find_cabal_file(ctx)

    local project_root = cfg.project_root or "."
    if stack_yaml ~= nil then
        project_root = dirname(stack_yaml)
    elseif cabal_file ~= nil then
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

    local main_hs = cfg.main_hs or M.find_main_hs(ctx, project_root)
    local bin_dir = cfg.bin_dir or "build/ghc/bin"
    local dist_dir = cfg.dist_dir or "dist-newstyle"

    local outputs = {}
    for _, name in ipairs(executables) do
        outputs[#outputs + 1] = bin_dir .. "/" .. name
    end

    if build_tool == "ghc" and main_hs ~= nil then
        outputs = { bin_dir .. "/" .. package_name }
    end

    return {
        build_tool = build_tool,
        stack_yaml = stack_yaml,
        cabal_file = cabal_file,
        project_root = project_root,
        package_name = package_name,
        executables = executables,
        main_hs = main_hs,
        bin_dir = bin_dir,
        dist_dir = dist_dir,
        primary_output = outputs[1],
        artifact_globs = {
            bin_dir .. "/**",
            dist_dir .. "/**",
        },
    }
end

return M
