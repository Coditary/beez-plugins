local M = {}

local EXCLUDED_DIRS = {
    ["build"] = true,
    ["bin"] = true,
    ["obj"] = true,
    [".git"] = true,
    ["packages"] = true,
}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function read_file(path)
    local file = io.open(path, "r")
    if file == nil then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

local function parse_csproj_tag(content, tag)
    if content == nil then
        return nil
    end
    return content:match("<" .. tag .. ">([^<]+)</" .. tag .. ">")
end

local function is_excluded_source(path)
    for segment in path:gmatch("[^/]+") do
        if EXCLUDED_DIRS[segment] then
            return true
        end
    end
    return false
end

function M.find_csproj(ctx)
    local projects = ctx.glob({ "*.csproj", "**/*.csproj" })
    if #projects == 0 then
        return nil
    end

    table.sort(projects)
    for _, project in ipairs(projects) do
        local name = basename(project):lower()
        if not name:match("%.tests%.csproj$") and not name:match("_test%.csproj$") then
            return project
        end
    end

    return projects[1]
end

function M.find_test_csproj(ctx)
    local projects = ctx.glob({ "*.csproj", "**/*.csproj", "**/*Tests.csproj", "**/*Test.csproj" })
    for _, project in ipairs(projects) do
        local name = basename(project):lower()
        if name:match("%.tests%.csproj$") or name:match("_test%.csproj$") or name:match("test%.csproj$") then
            return project
        end
    end
    return nil
end

function M.project_root(csproj_path)
    if csproj_path == nil then
        return "."
    end
    return dirname(csproj_path)
end

function M.parse_csproj(csproj_path)
    local content = read_file(csproj_path)
    if content == nil then
        return {}
    end

    local framework = parse_csproj_tag(content, "TargetFrameworkVersion") or "v4.5"
    local major = tonumber(framework:match("v(%d+)")) or 4

    return {
        assembly_name = parse_csproj_tag(content, "AssemblyName") or basename(csproj_path):gsub("%.csproj$", ""),
        output_type = parse_csproj_tag(content, "OutputType") or "Exe",
        framework_version = framework,
        framework_major = major,
    }
end

function M.resolve_compiler_binary(meta, cfg)
    if cfg.mcs_binary ~= nil and cfg.mcs_binary ~= "" then
        if cfg.mcs_binary == "dmcs" or (meta ~= nil and meta.framework_major >= 4) then
            return cfg.dmcs_binary or "dmcs"
        end
        return cfg.mcs_binary
    end

    if meta ~= nil and meta.framework_major >= 4 then
        return cfg.dmcs_binary or "dmcs"
    end

    return cfg.mcs_binary or "mcs"
end

function M.collect_source_files(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local sources = ctx.glob({
        prefix .. "**/*.cs",
    })

    local filtered = {}
    for _, source in ipairs(sources) do
        if not is_excluded_source(source) then
            filtered[#filtered + 1] = source
        end
    end

    table.sort(filtered)
    return filtered
end

function M.output_extension(output_type)
    if output_type ~= nil and output_type:lower() == "library" then
        return ".dll"
    end
    return ".exe"
end

function M.resolve(ctx, cfg)
    local csproj = cfg.csproj or M.find_csproj(ctx)
    local root = cfg.project_root or M.project_root(csproj)
    local meta = csproj ~= nil and M.parse_csproj(csproj) or {
        assembly_name = cfg.output_name or "app",
        output_type = "Exe",
        framework_version = "v4.5",
        framework_major = 4,
    }

    local sources = cfg.sources
    if sources == nil then
        sources = M.collect_source_files(ctx, root)
    end

    if #sources == 0 then
        error("mcs plugin: no C# source files found — add *.cs files or set sources in configure()")
    end

    local output_name = cfg.output_name or meta.assembly_name or "app"
    local bin_dir = cfg.bin_dir or "build/mcs/bin"
    local extension = M.output_extension(meta.output_type)
    local primary_output = bin_dir .. "/" .. output_name .. extension

    local test_csproj = cfg.test_csproj or M.find_test_csproj(ctx)
    local test_output = nil
    if test_csproj ~= nil then
        local test_meta = M.parse_csproj(test_csproj)
        test_output = bin_dir .. "/" .. test_meta.assembly_name .. ".dll"
    end

    return {
        csproj = csproj,
        test_csproj = test_csproj,
        project_root = root,
        meta = meta,
        sources = sources,
        bin_dir = bin_dir,
        primary_output = primary_output,
        test_output = test_output,
        compiler_binary = M.resolve_compiler_binary(meta, cfg),
    }
end

return M
