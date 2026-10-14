local command = require("src.command")
local config = require("src.config")
local defaults = require("src.defaults")

local M = {}

function M.setup(ctx, step_name)
    local profile_name = defaults.configure_step_profiles[step_name]
    if profile_name == nil then
        error("unknown twee setup step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("twee setup step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_setup .. " " .. profile.setup_description)
    return beez.shell.run(ctx, cfg.log_prefix_setup, command.verify_tool(cfg, ctx.project_root))
end

function M.compile(ctx, step_name)
    local profile_name = defaults.compile_step_profiles[step_name]
    if profile_name == nil then
        error("unknown twee compile step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("twee compile step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_compile .. " " .. profile.compile_description)
    return beez.shell.run(ctx, cfg.log_prefix_compile, command.compile(cfg, ctx.project_root))
end

function M.bundle(ctx, step_name)
    local profile_name = defaults.bundle_step_profiles[step_name]
    if profile_name == nil then
        error("unknown twee bundle step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("twee bundle step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_bundle .. " " .. profile.bundle_description)
    return beez.shell.run(ctx, cfg.log_prefix_bundle, command.verify_output(cfg, ctx.project_root))
end

function M.test(ctx, step_name)
    local profile_name = defaults.test_step_profiles[step_name]
    if profile_name == nil then
        error("unknown twee test step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("twee test step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_test .. " " .. profile.test_description)
    return beez.shell.run(ctx, cfg.log_prefix_test, command.test(cfg, ctx.project_root))
end



return M
