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

    local cmd_mains = ctx.glob({ prefix .. "cmd/*/main.go", prefix .. "cmd/**/main.go" })
    local targets, seen = {}, {}

    for _, main_path in ipairs(cmd_mains) do
        local cmd_dir = dirname(main_path)
        if not seen[cmd_dir] then
            seen[cmd_dir] = true
            targets[#targets + 1] = { package = "./" .. cmd_dir, name = basename(cmd_dir) }
        end
    end

    if #targets == 0 and #ctx.glob({ prefix .. "main.go" }) > 0 then
        targets[#targets + 1] = { package = ".", name = "app" }
    end

    if #targets == 0 then
        targets[#targets + 1] = { package = "./...", name = "app" }
    end

    return targets
end

function M.resolve(ctx, cfg)
    local go_mod = cfg.go_mod or M.find_go_mod(ctx)
    if go_mod == nil then
        error("gccgo plugin: no go.mod found")
    end

    local root = cfg.module_root or dirname(go_mod)
    local targets = cfg.targets or M.resolve_build_targets(ctx, root)
    local bin_dir = cfg.bin_dir or "build/gccgo/bin"

    for _, target in ipairs(targets) do
        target.output = target.output or (bin_dir .. "/" .. (target.name or "app"))
    end

    return {
        go_mod = go_mod,
        module_root = root,
        targets = targets,
        bin_dir = bin_dir,
    }
end

return M
