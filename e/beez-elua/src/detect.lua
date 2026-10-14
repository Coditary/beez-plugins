local M = {}

local function basename(path)
    return path:match("([^/]+)$") or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("^test/") ~= nil
end

function M.find_sconstruct(ctx)
    local matches = ctx.glob({ "SConstruct", "**/SConstruct" })
    if #matches == 0 then
        return nil
    end
    table.sort(matches)
    return matches[1]
end

function M.find_platform_data(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local matches = ctx.glob({
        prefix .. "platform_data.lua",
        prefix .. "src/platform_data.lua",
        "**/platform_data.lua",
    })

    if #matches == 0 then
        return nil
    end

    table.sort(matches)
    return matches[1]
end

function M.resolve_app_scripts(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local scripts = ctx.glob({
        prefix .. "src/**/*.lua",
        prefix .. "src/*.lua",
    })

    local filtered = {}
    for _, path in ipairs(scripts) do
        if not is_test_path(path) and basename(path) ~= "platform_data.lua" then
            filtered[#filtered + 1] = path
        end
    end

    table.sort(filtered)
    return filtered
end

function M.resolve(ctx, cfg)
    local sconstruct = cfg.sconstruct or M.find_sconstruct(ctx)
    if sconstruct == nil then
        error("elua plugin: no SConstruct found — add an eLua project or set sconstruct in configure()")
    end

    local root = cfg.project_root or dirname(sconstruct)
    local platform_data = cfg.platform_data or M.find_platform_data(ctx, root)
    local platform = cfg.platform
        or beez.env_or("ELUA_TARGET", cfg.default_platform or "linux")

    local bin_dir = cfg.bin_dir or "build/elua"
    local app_scripts = cfg.app_scripts or M.resolve_app_scripts(ctx, root)

    if platform_data == nil and #app_scripts == 0 then
        error("elua plugin: no platform_data.lua or src/**/*.lua found — add eLua project markers")
    end

    return {
        project_root = root,
        sconstruct = sconstruct,
        platform_data = platform_data,
        platform = platform,
        bin_dir = bin_dir,
        app_scripts = app_scripts,
        primary_output = bin_dir .. "/" .. platform,
        elua_build_subdir = cfg.elua_build_subdir or "0.9",
    }
end

return M
