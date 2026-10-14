local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    return path:match("([^/]+)$") or path
end

function M.find_build_zig(ctx)
    local files = ctx.glob({ "build.zig", "**/build.zig" })
    if #files == 0 then
        return nil
    end

    table.sort(files)
    return files[1]
end

function M.find_build_zig_zon(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""
    local files = ctx.glob({
        prefix .. "build.zig.zon",
        "build.zig.zon",
        "**/build.zig.zon",
    })
    if #files == 0 then
        return nil
    end

    table.sort(files)
    return files[1]
end

function M.resolve_sources(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local sources = ctx.glob({
        prefix .. "src/main.zig",
        prefix .. "src/*.zig",
        prefix .. "src/**/*.zig",
    })

    table.sort(sources)
    return sources
end

function M.resolve_binary_name(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""
    local mains = ctx.glob({ prefix .. "src/main.zig" })

    if #mains > 0 then
        local build_zig = M.find_build_zig(ctx)
        if build_zig ~= nil then
            local project_name = basename(dirname(build_zig))
            if project_name ~= "." then
                return project_name
            end
        end
        return "app"
    end

    local sources = M.resolve_sources(ctx, root)
    if #sources > 0 then
        local first = sources[1]
        local name = basename(first):gsub("%.zig$", "")
        return name ~= "" and name or "app"
    end

    return "app"
end

function M.resolve(ctx, cfg)
    local build_zig = cfg.build_zig or M.find_build_zig(ctx)
    if build_zig == nil then
        error("zig plugin: no build.zig found — add a Zig project or set build_zig in configure()")
    end

    local root = cfg.project_root or dirname(build_zig)
    local build_zig_zon = cfg.build_zig_zon or M.find_build_zig_zon(ctx, root)
    local sources = cfg.sources or M.resolve_sources(ctx, root)
    local binary_name = cfg.binary_name or M.resolve_binary_name(ctx, root)
    local bin_dir = cfg.bin_dir or "zig-out/bin"

    return {
        build_zig = build_zig,
        build_zig_zon = build_zig_zon,
        project_root = root,
        sources = sources,
        binary_name = binary_name,
        bin_dir = bin_dir,
        primary_output = bin_dir .. "/" .. binary_name,
        has_zon = build_zig_zon ~= nil,
    }
end

return M
