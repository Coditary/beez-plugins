local defaults = require("src.defaults")

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

function M.find_nim_source_root(ctx)
    local compiler_nim = ctx.glob({ "compiler/nim.nim", "**/compiler/nim.nim" })
    if #compiler_nim > 0 then
        sort_shallow_first(compiler_nim)
        local path = compiler_nim[1]
        local root = path:match("^(.*)/compiler/nim%.nim$")
        if root ~= nil and root ~= "" then
            return root
        end
    end

    local build_scripts = ctx.glob({ "build_nim.sh", "**/build_nim.sh" })
    if #build_scripts > 0 then
        sort_shallow_first(build_scripts)
        return dirname(build_scripts[1])
    end

    local nims = ctx.glob({ "**/*.nim" })
    if #nims > 0 then
        return "."
    end

    error("nim-csources plugin: no Nim source tree found — add compiler/nim.nim, build_nim.sh, or *.nim files")
end

function M.find_csources_dir(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    for _, name in ipairs(defaults.csources_dir_candidates) do
        local build_sh = ctx.glob({ prefix .. name .. "/build.sh" })
        if #build_sh > 0 then
            return name
        end
    end

    return nil
end

function M.find_build_nim_script(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""
    local preferred = prefix .. "build_nim.sh"
    local scripts = ctx.glob({ preferred, "build_nim.sh", "**/build_nim.sh" })
    if #scripts == 0 then
        return nil
    end

    sort_shallow_first(scripts)
    for _, script in ipairs(scripts) do
        if script == preferred or script == "build_nim.sh" then
            return script
        end
    end

    return scripts[1]
end

function M.has_koch(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""
    return #ctx.glob({ prefix .. "koch.nim", "koch.nim" }) > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or M.find_nim_source_root(ctx)
    local csources_dir = cfg.csources_dir or M.find_csources_dir(ctx, root)
    local build_nim_script = cfg.build_nim_script or M.find_build_nim_script(ctx, root)
    local has_koch = M.has_koch(ctx, root)

    if csources_dir == nil and build_nim_script == nil then
        error("nim-csources plugin: no csources directory or build_nim.sh found — clone csources_v3 or add build_nim.sh")
    end

    local bin_dir = cfg.bin_dir or defaults.bin_dir
    local bootstrap_nim = bin_dir .. "/" .. (cfg.nim_bootstrap_name or defaults.nim_bootstrap_name)
    local nim_output = bin_dir .. "/" .. (cfg.nim_binary or defaults.nim_binary)

    return {
        project_root = root,
        csources_dir = csources_dir,
        build_nim_script = build_nim_script,
        has_koch = has_koch,
        bin_dir = bin_dir,
        bootstrap_nim = bootstrap_nim,
        nim_output = nim_output,
        primary_output = nim_output,
    }
end

return M
