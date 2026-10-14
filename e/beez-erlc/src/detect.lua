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

function M.find_rebar_config(ctx)
    local files = ctx.glob({ "rebar.config", "**/rebar.config" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_mix_exs(ctx)
    local files = ctx.glob({ "mix.exs", "**/mix.exs" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.has_elixir_sources(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local ex_files = ctx.glob({ prefix .. "lib/**/*.ex", prefix .. "src/**/*.ex" })
    return #ex_files > 0
end

function M.is_erlang_mix_project(ctx, mix_exs, project_root)
    if mix_exs == nil then
        return false
    end

    if M.has_elixir_sources(ctx, project_root) then
        return false
    end

    local prefix = glob_prefix(project_root)
    local erl_files = ctx.glob({
        prefix .. "src/**/*.erl",
        prefix .. "lib/**/*.erl",
        prefix .. "**/*.erl",
    })

    for _, file in ipairs(erl_files) do
        if not file:match("/_build/") and not file:match("/deps/") then
            return true
        end
    end

    return false
end

function M.resolve_source_roots(ctx, project_root)
    local prefix = glob_prefix(project_root)
    local roots = {
        prefix .. "src",
        prefix .. "lib",
        prefix,
    }

    local sources = {}
    local include_dirs = {}
    local seen = {}

    for _, root in ipairs(roots) do
        local files = ctx.glob({ root .. "/**/*.erl", root .. "/*.erl" })
        for _, file in ipairs(files) do
            if not file:match("/_build/") and not file:match("/deps/") and not seen[file] then
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
            if not file:match("/_build/") and not file:match("/deps/") and not seen[file] then
                seen[file] = true
                sources[#sources + 1] = file
            end
        end
    end

    local include_candidates = {
        prefix .. "include",
        prefix .. "src",
        prefix .. "lib",
    }

    for _, dir in ipairs(include_candidates) do
        local headers = ctx.glob({ dir .. "/**/*.hrl", dir .. "/*.hrl" })
        if #headers > 0 then
            include_dirs[#include_dirs + 1] = dir
        end
    end

    return sources, include_dirs
end

function M.resolve(ctx, cfg)
    local rebar_config = cfg.rebar_config
    local mix_exs = cfg.mix_exs
    local backend = cfg.backend

    if rebar_config == nil then
        rebar_config = M.find_rebar_config(ctx)
    end

    if mix_exs == nil then
        mix_exs = M.find_mix_exs(ctx)
    end

    local project_root = cfg.project_root
    if project_root == nil then
        if rebar_config ~= nil then
            project_root = dirname(rebar_config)
        elseif mix_exs ~= nil then
            project_root = dirname(mix_exs)
        else
            project_root = "."
        end
    end

    if backend == nil then
        if rebar_config ~= nil then
            backend = "rebar3"
        elseif M.is_erlang_mix_project(ctx, mix_exs, project_root) then
            backend = "mix"
        else
            backend = "erlc"
        end
    end

    local sources = cfg.sources
    local include_dirs = cfg.include_dirs
    if sources == nil or include_dirs == nil then
        local detected_sources, detected_include_dirs = M.resolve_source_roots(ctx, project_root)
        if sources == nil then
            sources = detected_sources
        end
        if include_dirs == nil then
            include_dirs = detected_include_dirs
        end
    end

    if backend == "erlc" and #sources == 0 then
        error("erlc plugin: no Erlang sources found — add .erl files or a rebar.config")
    end

    if backend == "rebar3" and rebar_config == nil then
        error("erlc plugin: rebar3 backend selected but no rebar.config found")
    end

    if backend == "mix" and mix_exs == nil then
        error("erlc plugin: mix backend selected but no mix.exs found")
    end

    local ebin_dir = cfg.ebin_dir or "build/erlc/ebin"

    return {
        backend = backend,
        rebar_config = rebar_config,
        mix_exs = mix_exs,
        project_root = project_root,
        sources = sources,
        include_dirs = include_dirs,
        ebin_dir = ebin_dir,
        primary_output = ebin_dir,
    }
end

return M
