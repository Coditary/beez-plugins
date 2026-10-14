local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local da = select(2, a:gsub("/", ""))
        local db = select(2, b:gsub("/", ""))
        if da == db then return a < b end
        return da < db
    end)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "top.v",
        prefix .. "main.v",
        prefix .. "tb.v",
        prefix .. "src/top.v",
        prefix .. "hdl/top.v"
    }
    local primary = nil
    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        if #matches > 0 then
            primary = matches[1]
            break
        end
    end
    if primary == nil then
        local matches = ctx.glob({ prefix .. "**/*.v" })
        sort_shallow_first(matches)
        primary = matches[1]
    end
    if primary == nil then
        error("iverilog plugin: no Verilog .v source found")
    end
    local bin_dir = cfg.bin_dir or "build/iverilog"
    local vvp_out = bin_dir .. "/sim.vvp"
    return {
        project_root = root,
        package_name = cfg.output_name or "app",
        targets = { { source = primary, name = "top", output = vvp_out } },
        bin_dir = bin_dir,
        primary_source = primary,
        primary_output = vvp_out,
        entry_targets = { { source = primary, name = "top", output = vvp_out } },
    }
end

return M
