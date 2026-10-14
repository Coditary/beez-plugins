local M = {}

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

local function parse_dub_name(manifest_path)
    local content = read_file(manifest_path)
    if content == nil then
        return nil
    end

    if manifest_path:match("%.json$") then
        return content:match('"name"%s*:%s*"([^"]+)"')
    end

    return content:match('name%s+"([^"]+)"')
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

function M.find_dub_manifest(ctx)
    local manifests = ctx.glob({ "dub.json", "dub.sdl", "**/dub.json", "**/dub.sdl" })
    if #manifests == 0 then
        return nil
    end

    sort_shallow_first(manifests)
    return manifests[1]
end

function M.project_root(manifest_path)
    return dirname(manifest_path)
end

function M.resolve_plain_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local sources = ctx.glob({
        prefix .. "source/**/*.d",
        prefix .. "source/*.d",
        prefix .. "src/**/*.d",
        prefix .. "src/*.d",
        prefix .. "*.d",
    })

    local seen = {}
    local unique = {}
    for _, source in ipairs(sources) do
        if not seen[source] then
            seen[source] = true
            unique[#unique + 1] = source
        end
    end

    table.sort(unique)
    return unique
end

function M.resolve_output_name(ctx, root, cfg)
    if cfg.output_name ~= nil and cfg.output_name ~= "" then
        return cfg.output_name
    end

    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    if #ctx.glob({ prefix .. "source/app.d" }) > 0 then
        return "app"
    end

    return "app"
end

function M.resolve(ctx, cfg)
    local dub_manifest = cfg.dub_manifest or M.find_dub_manifest(ctx)
    local bin_dir = cfg.bin_dir or "build/dmd/bin"

    if dub_manifest ~= nil then
        local root = cfg.project_root or M.project_root(dub_manifest)
        local output_name = cfg.output_name or parse_dub_name(dub_manifest) or M.resolve_output_name(ctx, root, cfg)

        return {
            project_type = "dub",
            dub_manifest = dub_manifest,
            project_root = root,
            sources = {},
            output_name = output_name,
            bin_dir = bin_dir,
            primary_output = bin_dir .. "/" .. output_name,
        }
    end

    local root = cfg.project_root or "."
    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_plain_sources(ctx, root)
    end

    if #sources == 0 then
        error("dmd plugin: no dub.json/dub.sdl or .d sources found — add a D project or set sources in configure()")
    end

    local output_name = M.resolve_output_name(ctx, root, cfg)

    return {
        project_type = "plain",
        dub_manifest = nil,
        project_root = root,
        sources = sources,
        output_name = output_name,
        bin_dir = bin_dir,
        primary_output = bin_dir .. "/" .. output_name,
    }
end

return M
