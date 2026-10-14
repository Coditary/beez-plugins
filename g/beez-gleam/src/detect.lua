local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function depth(path)
    return select(2, path:gsub("/", ""))
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = depth(a)
        local depth_b = depth(b)
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function is_project_source(path)
    return not path:match("/build/")
        and not path:match("/deps/")
end

function M.find_gleam_toml(ctx)
    local files = ctx.glob({ "gleam.toml", "**/gleam.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local roots = {
        prefix .. "src",
        prefix,
    }

    local sources = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({
            root .. "/**/*.gleam",
            root .. "/*.gleam",
        })
        for _, file in ipairs(files) do
            if is_project_source(file) and not seen[file] then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
        if #sources > 0 then
            break
        end
    end

    if #sources == 0 then
        local all = ctx.glob({ prefix .. "**/*.gleam" })
        for _, file in ipairs(all) do
            if is_project_source(file) and not seen[file] then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
    end

    return sources
end

function M.resolve(ctx, cfg)
    local gleam_toml = cfg.gleam_toml

    if gleam_toml == nil then
        gleam_toml = M.find_gleam_toml(ctx)
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if gleam_toml ~= nil then
            project_root = dirname(gleam_toml)
        else
            project_root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_roots(ctx, project_root)
    end

    if gleam_toml == nil then
        error("gleam plugin: no gleam.toml found — add a Gleam project manifest")
    end

    if #sources == 0 then
        error("gleam plugin: no Gleam sources found — add .gleam files under src/")
    end

    local ebin_dir = cfg.ebin_dir or "build/gleam/ebin"

    return {
        gleam_toml = gleam_toml,
        project_root = project_root,
        sources = sources,
        ebin_dir = ebin_dir,
        primary_output = ebin_dir,
    }
end

return M
