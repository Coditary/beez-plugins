local command = require("src.command")
local config = require("src.config")
local defaults = require("src.defaults")

local M = {}

local function log_prefix_for_compiler(compiler)
    return "[" .. compiler .. "]"
end

function M.setup(ctx, step_name)
    local profile_name = defaults.configure_step_profiles[step_name]
    if profile_name == nil then
        error("unknown go setup step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("go setup step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local prefix = log_prefix_for_compiler(cfg.compiler)

    print(prefix .. " " .. cfg.setup_description)
    return beez.shell.run(ctx, prefix, command.mod_download(cfg, ctx.project_root))
end

function M.compile(ctx, step_name)
    local profile_name = defaults.compile_step_profiles[step_name]
    if profile_name == nil then
        error("unknown go compile step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("go compile step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local prefix = log_prefix_for_compiler(cfg.compiler)

    print(prefix .. " " .. cfg.compile_description)
    return beez.shell.run(ctx, prefix, command.build_all(cfg, ctx.project_root))
end

function M.bundle(ctx, step_name)
    local profile_name = defaults.bundle_step_profiles[step_name]
    if profile_name == nil then
        error("unknown go bundle step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("go bundle step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local prefix = log_prefix_for_compiler(cfg.compiler)

    print(prefix .. " " .. cfg.bundle_description)
    return beez.shell.run(ctx, prefix, command.install_stamp(cfg, ctx.project_root))
end

function M.test(ctx, step_name)
    local profile_name = defaults.test_step_profiles[step_name]
    if profile_name == nil then
        error("unknown go test step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("go test step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local prefix = log_prefix_for_compiler(cfg.compiler)

    print(prefix .. " " .. cfg.test_description)
    return beez.shell.run(ctx, prefix, command.test(cfg, ctx.project_root))
end


function M.run(ctx, step_name)
    local profile_name = defaults.run_step_profiles[step_name]
    if profile_name == nil then
        error("unknown run step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("run step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]
    local log_prefix = cfg.log_prefix_run or defaults.log_prefix_run or "[run]"

    print(log_prefix .. " " .. (profile.run_description or "Run application"))
    return beez.shell.run(ctx, log_prefix, command.run(cfg, ctx.project_root))
end

return M
