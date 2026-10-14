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

function M.find_build_file(ctx)
    local files = ctx.glob({
        "Myrddin.build",
        "**/Myrddin.build",
        "bld.proj",
        "**/bld.proj",
    })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(build_file)
    if build_file == nil then
        return "."
    end
    return dirname(build_file)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_entry_source(ctx, root)
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "main.myr",
        prefix .. "hello.myr",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    local sources = ctx.glob({ prefix .. "*.myr" })
    sort_shallow_first(sources)
    if #sources > 0 then
        return sources[1]
    end

    return nil
end

function M.has_build_file(ctx, root)
    local prefix = glob_prefix(root)
    local build_files = ctx.glob({
        prefix .. "Myrddin.build",
        prefix .. "bld.proj",
    })
    return #build_files > 0
end

function M.resolve(ctx, cfg)
    local build_file = cfg.build_file
    if build_file == nil then
        build_file = M.find_build_file(ctx)
    end

    local sources = ctx.glob({ "**/*.myr" })
    if build_file == nil and #sources == 0 then
        error("myrddin plugin: no Myrddin.build, bld.proj, or *.myr files found — add a Myrddin project or set build_file in configure()")
    end

    local root = cfg.project_root or M.project_root(build_file)
    local entry_source = cfg.entry_source
    if entry_source == nil then
        entry_source = M.resolve_entry_source(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/myrddin/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_build_file = cfg.has_build_file
    if has_build_file == nil then
        has_build_file = build_file ~= nil or M.has_build_file(ctx, root)
    end

    return {
        build_file = build_file,
        has_build_file = has_build_file,
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
