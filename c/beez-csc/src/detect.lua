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

function M.find_sln(ctx)
    local solutions = ctx.glob({ "*.sln", "**/*.sln" })
    if #solutions == 0 then
        return nil
    end

    sort_shallow_first(solutions)
    return solutions[1]
end

function M.find_csproj(ctx)
    local projects = ctx.glob({ "*.csproj", "**/*.csproj" })
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
        prefix .. "**/*.cs",
    })
end

function M.detect_toolchain(ctx, cfg)
    if cfg.toolchain ~= nil and cfg.toolchain ~= "" then
        return cfg.toolchain
    end

    if M.find_sln(ctx) ~= nil or M.find_csproj(ctx) ~= nil then
        return "dotnet"
    end

    local sources = ctx.glob({ "**/*.cs" })
    if #sources > 0 then
        return "csc"
    end

    error("csc plugin: no *.sln, *.csproj, or **/*.cs found — add a C# project or set project_file in configure()")
end

function M.resolve_project(ctx, cfg)
    local sln = cfg.sln or M.find_sln(ctx)
    if sln ~= nil then
        return {
            project_file = sln,
            project_root = cfg.project_root or dirname(sln),
            project_kind = "sln",
        }
    end

    local csproj = cfg.csproj or cfg.project_file or M.find_csproj(ctx)
    if csproj ~= nil then
        return {
            project_file = csproj,
            project_root = cfg.project_root or dirname(csproj),
            project_kind = "csproj",
        }
    end

    local root = cfg.project_root or "."
    local sources = cfg.source_files
    if sources == nil then
        sources = M.find_source_files(ctx, root)
    end

    if #sources == 0 then
        error("csc plugin: no *.sln, *.csproj, or **/*.cs found — add a C# project or set source_files in configure()")
    end

    return {
        project_file = nil,
        project_root = root,
        project_kind = "sources",
        source_files = sources,
    }
end

function M.resolve(ctx, cfg)
    local toolchain = M.detect_toolchain(ctx, cfg)
    local project = M.resolve_project(ctx, cfg)
    local build_dir = cfg.build_dir or "build/csc"
    local output_name = cfg.output_name or "app"

    local primary_output
    if toolchain == "dotnet" then
        primary_output = build_dir
    else
        primary_output = build_dir .. "/" .. output_name .. ".dll"
    end

    return {
        toolchain = toolchain,
        project_file = project.project_file,
        project_root = project.project_root,
        project_kind = project.project_kind,
        source_files = project.source_files,
        build_dir = build_dir,
        bin_dir = cfg.bin_dir or build_dir,
        primary_output = primary_output,
        output_name = output_name,
    }
end

return M
