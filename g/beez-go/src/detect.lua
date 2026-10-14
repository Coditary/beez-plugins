local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

function M.find_go_mod(ctx)
    local mods = ctx.glob({ "go.mod", "**/go.mod" })
    if #mods == 0 then
        return nil
    end

    table.sort(mods)
    return mods[1]
end

function M.module_root(go_mod_path)
    return dirname(go_mod_path)
end

function M.resolve_build_targets(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local cmd_mains = ctx.glob({
        prefix .. "cmd/*/main.go",
        prefix .. "cmd/**/main.go",
    })

    local targets = {}
    local seen = {}

    for _, main_path in ipairs(cmd_mains) do
        local cmd_dir = dirname(main_path)
        local name = basename(cmd_dir)
        if not seen[cmd_dir] then
            seen[cmd_dir] = true
            targets[#targets + 1] = {
                package = "./" .. cmd_dir,
                name = name,
                output = nil,
            }
        end
    end

    if #targets == 0 then
        local root_main = ctx.glob({ prefix .. "main.go" })
        if #root_main > 0 then
            targets[#targets + 1] = {
                package = ".",
                name = "app",
                output = nil,
            }
        end
    end

    if #targets == 0 then
        targets[#targets + 1] = {
            package = "./...",
            name = "app",
            output = nil,
        }
    end

    return targets
end

function M.resolve(ctx, cfg)
    local go_mod = cfg.go_mod or M.find_go_mod(ctx)
    if go_mod == nil then
        error("go plugin: no go.mod found — add a Go module or set go_mod in configure()")
    end

    local root = cfg.module_root or M.module_root(go_mod)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/go/bin"

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    return {
        go_mod = go_mod,
        module_root = root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_package = targets[1].package,
    }
end

return M
