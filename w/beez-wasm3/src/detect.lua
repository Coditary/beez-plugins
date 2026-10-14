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
    local matches = ctx.glob({ "**/*.wasm", "build/**/*.wasm", "dist/**/*.wasm" })
    if #matches == 0 then
        error("wasm3 plugin: no .wasm file found — build with emscripten/tinygo/etc. or set primary_output")
    end
    sort_shallow_first(matches)
    local wasm = matches[1]
    local root = cfg.project_root or "."
    local bin_dir = cfg.bin_dir or "build/wasm3"
    return {
        project_root = root,
        package_name = cfg.output_name or "app",
        targets = { { source = wasm, name = "app", output = wasm } },
        bin_dir = bin_dir,
        primary_source = wasm,
        primary_output = wasm,
        entry_targets = { { source = wasm, name = "app", output = wasm } },
    }
end

return M
