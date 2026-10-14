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

function M.find_rebar_config(ctx)
    local configs = ctx.glob({ "rebar.config", "**/rebar.config" })
    if #configs == 0 then
        return nil
    end

    sort_shallow_first(configs)
    return configs[1]
end

function M.resolve_source_files(ctx, project_root)
    local prefix = project_root
    if project_root ~= "." and project_root ~= "" then
        prefix = project_root .. "/"
    else
        prefix = ""
    end

    local roots = {
        prefix .. "src",
        prefix,
    }

    local sources = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({ root .. "/**/*.erl", root .. "/*.erl" })
        for _, file in ipairs(files) do
            if not seen[file]
                and not file:match("/_build/")
                and not file:match("/deps/")
                and not file:match("/%.git/")
            then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
        if #sources > 0 then
            break
        end
    end

    if #sources == 0 then
        local all = ctx.glob({ prefix .. "**/*.erl" })
        for _, file in ipairs(all) do
            if not seen[file]
                and not file:match("/_build/")
                and not file:match("/deps/")
                and not file:match("/%.git/")
            then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
    end

    table.sort(sources)
    return sources
end

function M.resolve(ctx, cfg)
    local rebar_config = cfg.rebar_config
    local backend = cfg.backend

    if rebar_config == nil then
        rebar_config = M.find_rebar_config(ctx)
    end

    if backend == nil then
        backend = rebar_config ~= nil and "rebar3" or "erlc"
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if rebar_config ~= nil then
            project_root = dirname(rebar_config)
        else
            project_root = "."
        end
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.resolve_source_files(ctx, project_root)
    end

    if backend == "erlc" and #sources == 0 then
        error("hipe plugin: no Erlang sources found — add .erl files or a rebar.config project")
    end

    if backend == "rebar3" and rebar_config == nil then
        error("hipe plugin: rebar3 backend selected but no rebar.config found")
    end

    local output_name = cfg.output_name or "app"
    local ebin_dir = cfg.ebin_dir or "build/hipe/ebin"
    local bin_dir = cfg.bin_dir or "build/hipe/bin"

    return {
        backend = backend,
        rebar_config = rebar_config,
        project_root = project_root,
        sources = sources,
        ebin_dir = ebin_dir,
        bin_dir = bin_dir,
        primary_output = ebin_dir,
        launcher_output = bin_dir .. "/" .. output_name,
    }
end

return M
