local M = {}

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local da = select(2, a:gsub("/", ""))
        local db = select(2, b:gsub("/", ""))
        if da == db then return a < b end
        return da < db
    end)
end

function M.resolve(ctx, cfg)
    local matches = ctx.glob({ "**/*.love", "dist/**/*.love", "build/**/*.love" })
    if #matches == 0 then
        error("love2d plugin: no .love package found")
    end
    sort_shallow_first(matches)
    local love_pkg = matches[1]
    local root = cfg.project_root or "."
    local bin_dir = cfg.bin_dir or "build/love2d"
    return {
        project_root = root,
        package_name = cfg.output_name or "app",
        targets = { { source = love_pkg, name = "app", output = nil } },
        bin_dir = bin_dir,
        primary_source = love_pkg,
        entry_targets = { { source = love_pkg, name = "app", output = nil } },
    }
end

return M
