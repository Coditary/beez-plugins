local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
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

function M.find_elm_json(ctx)
    local files = ctx.glob({ "elm.json", "**/elm.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(elm_json_path)
    if elm_json_path == nil then
        return "."
    end
    return dirname(elm_json_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_main_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "src/Main.elm",
        prefix .. "Main.elm",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    local src_files = ctx.glob({ prefix .. "src/*.elm" })
    sort_shallow_first(src_files)
    for _, source in ipairs(src_files) do
        if not source:match("/tests/") and not source:match("/test/") then
            return source
        end
    end

    error("elm plugin: no Main.elm entry point found — add src/Main.elm or configure main_source in configure()")
end

function M.resolve(ctx, cfg)
    local elm_json_path = cfg.elm_json_path
    if elm_json_path == nil then
        elm_json_path = M.find_elm_json(ctx)
    end

    local elms = ctx.glob({ "**/*.elm" })
    if elm_json_path == nil and #elms == 0 then
        error("elm plugin: no elm.json or *.elm files found — add an Elm project or set elm_json_path in configure()")
    end

    local root = cfg.project_root or M.project_root(elm_json_path)
    local main_source = cfg.main_source or M.resolve_main_source(ctx, root)
    local output_dir = cfg.output_dir or "build/elm"
    local output_name = cfg.output_name or "app.js"
    local primary_output = output_dir .. "/" .. output_name

    return {
        elm_json_path = elm_json_path,
        has_elm_json = elm_json_path ~= nil,
        project_root = root,
        main_source = main_source,
        output_dir = output_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
