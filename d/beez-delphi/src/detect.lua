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

function M.find_dproj(ctx)
    local projects = ctx.glob({ "*.dproj", "**/*.dproj" })
    if #projects == 0 then
        return nil
    end

    sort_shallow_first(projects)
    return projects[1]
end

function M.find_dpr(ctx)
    local programs = ctx.glob({ "*.dpr", "**/*.dpr" })
    if #programs == 0 then
        return nil
    end

    sort_shallow_first(programs)
    return programs[1]
end

function M.find_test_dproj(ctx)
    local projects = ctx.glob({
        "*Test.dproj",
        "**/*Test.dproj",
        "*Tests.dproj",
        "**/*Tests.dproj",
    })
    if #projects == 0 then
        return nil
    end

    sort_shallow_first(projects)
    return projects[1]
end

function M.resolve_compiler(cfg)
    if cfg.delphi_binary ~= nil and cfg.delphi_binary ~= "" then
        return cfg.delphi_binary
    end

    local arch = cfg.delphi_arch or beez.env_or("DELPHI_ARCH", "32")
    if arch == "64" or arch == "win64" or arch == "Win64" then
        return cfg.delphi_binary_64 or "dcc64"
    end

    return "dcc32"
end

function M.detect_toolchain(ctx, cfg)
    if cfg.toolchain ~= nil and cfg.toolchain ~= "" then
        return cfg.toolchain
    end

    if M.find_dproj(ctx) ~= nil then
        return "msbuild"
    end

    if M.find_dpr(ctx) ~= nil then
        return "dcc"
    end

    local sources = ctx.glob({ "**/*.pas" })
    if #sources > 0 then
        error("delphi plugin: found .pas files but no .dproj or .dpr — add a Delphi project file")
    end

    error("delphi plugin: no *.dproj, *.dpr, or **/*.pas found — add a Delphi project or set project_file in configure()")
end

function M.resolve_project(ctx, cfg)
    local dproj = cfg.dproj or cfg.project_file or M.find_dproj(ctx)
    if dproj ~= nil then
        return {
            project_file = dproj,
            project_root = cfg.project_root or dirname(dproj),
            project_kind = "dproj",
            output_name = cfg.output_name or stem(dproj),
        }
    end

    local dpr = cfg.dpr or M.find_dpr(ctx)
    if dpr ~= nil then
        return {
            project_file = dpr,
            project_root = cfg.project_root or dirname(dpr),
            project_kind = "dpr",
            output_name = cfg.output_name or stem(dpr),
        }
    end

    error("delphi plugin: no *.dproj or *.dpr found — add a Delphi project or set project_file in configure()")
end

function M.resolve(ctx, cfg)
    local toolchain = M.detect_toolchain(ctx, cfg)
    local project = M.resolve_project(ctx, cfg)
    local bin_dir = cfg.bin_dir or "build/delphi/bin"
    local dcu_dir = cfg.dcu_dir or "build/delphi/dcu"
    local build_dir = cfg.build_dir or "build/delphi"
    local output_name = project.output_name
    local primary_output = bin_dir .. "/" .. output_name .. ".exe"
    local test_dproj = cfg.test_dproj or M.find_test_dproj(ctx)

    return {
        toolchain = toolchain,
        delphi_binary = M.resolve_compiler(cfg),
        project_file = project.project_file,
        project_root = project.project_root,
        project_kind = project.project_kind,
        build_dir = build_dir,
        bin_dir = bin_dir,
        dcu_dir = dcu_dir,
        primary_output = primary_output,
        output_name = output_name,
        test_dproj = test_dproj,
    }
end

return M
