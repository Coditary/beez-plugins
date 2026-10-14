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
    return not path:match("/_build/")
        and not path:match("/deps/")
        and not path:match("/build/")
end

function M.find_mix_exs(ctx)
    local files = ctx.glob({ "mix.exs", "**/mix.exs" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local roots = {
        prefix .. "lib",
        prefix .. "src",
        prefix,
    }

    local sources = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({
            root .. "/**/*.ex",
            root .. "/**/*.exs",
            root .. "/*.ex",
            root .. "/*.exs",
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
        local all = ctx.glob({ prefix .. "**/*.ex", prefix .. "**/*.exs" })
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
    local mix_exs = cfg.mix_exs
    local backend = cfg.backend

    if mix_exs == nil then
        mix_exs = M.find_mix_exs(ctx)
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if mix_exs ~= nil then
            project_root = dirname(mix_exs)
        else
            project_root = "."
        end
    end

    if backend == nil then
        if mix_exs ~= nil then
            backend = "mix"
        else
            backend = "elixirc"
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_roots(ctx, project_root)
    end

    if backend == "elixirc" and #sources == 0 then
        error("elixirc plugin: no Elixir sources found — add .ex/.exs files or a mix.exs")
    end

    if backend == "mix" and mix_exs == nil then
        error("elixirc plugin: mix backend selected but no mix.exs found")
    end

    local ebin_dir = cfg.ebin_dir or "build/elixirc/ebin"

    return {
        backend = backend,
        mix_exs = mix_exs,
        project_root = project_root,
        sources = sources,
        ebin_dir = ebin_dir,
        primary_output = ebin_dir,
    }
end

return M
