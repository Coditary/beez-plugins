local M = {}

local function basename(path)
    return path:match("([^/]+)$") or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

function M.find_go_mod(ctx)
    local mods = ctx.glob({ "go.mod", "**/go.mod" })
    if #mods == 0 then return nil end
    table.sort(mods)
    return mods[1]
end

function M.resolve_build_targets(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local cmd_mains = ctx.glob({
        prefix .. "cmd/*/main.go",
        prefix .. "cmd/wasm/**/main.go",
        prefix .. "wasm/**/main.go",
        prefix .. "embedded/**/main.go",
        prefix .. "main.go",
    })

    local targets, seen = {}, {}

    for _, main_path in ipairs(cmd_mains) do
        local dir = dirname(main_path)
        local name = basename(dir)
        if dir == "." or dir == root then
            name = "app"
        end
        if not seen[dir] then
            seen[dir] = true
            local package = "."
            if dir ~= "." and dir ~= root then
                package = "./" .. dir
            end
            targets[#targets + 1] = { package = package, name = name }
        end
    end

    if #targets == 0 then
        targets[#targets + 1] = { package = ".", name = "app" }
    end

    return targets
end

function M.resolve(ctx, cfg)
    local go_mod = cfg.go_mod or M.find_go_mod(ctx)
    local root = cfg.module_root or (go_mod and dirname(go_mod)) or "."

    local targets = cfg.targets or M.resolve_build_targets(ctx, root)
    local bin_dir = cfg.bin_dir or "build/tinygo/wasm"

    for _, target in ipairs(targets) do
        local output = bin_dir .. "/" .. (target.name or "app")
        if cfg.tinygo_target == "wasm" or cfg.tinygo_target == "wasi" then
            if not output:match("%.wasm$") then
                output = output .. ".wasm"
            end
        end
        target.output = target.output or output
    end

    return {
        go_mod = go_mod,
        module_root = root,
        targets = targets,
        bin_dir = bin_dir,
    }
end

return M
