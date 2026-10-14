local command = require("src.command")
local config = require("src.config")
local defaults = require("src.defaults")

local M = {}

function M.setup(ctx, step_name)
    local profile_name = defaults.configure_step_profiles[step_name]
    if profile_name == nil then
        error("unknown cue setup step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("cue setup step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_setup .. " " .. profile.setup_description)
    return beez.shell.run(ctx, cfg.log_prefix_setup, command.verify_cue(cfg, ctx.project_root))
end

function M.compile(ctx, step_name)
    local profile_name = defaults.compile_step_profiles[step_name]
    if profile_name == nil then
        error("unknown cue compile step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("cue compile step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_compile .. " " .. profile.compile_description)
    return beez.shell.run(ctx, cfg.log_prefix_compile, command.compile(cfg, ctx.project_root))
end

function M.bundle(ctx, step_name)
    local profile_name = defaults.bundle_step_profiles[step_name]
    if profile_name == nil then
        error("unknown cue bundle step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("cue bundle step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_bundle .. " " .. profile.bundle_description)
    return beez.shell.run(ctx, cfg.log_prefix_bundle, command.verify_output(cfg, ctx.project_root))
end

function M.test(ctx, step_name)
    local profile_name = defaults.test_step_profiles[step_name]
    if profile_name == nil then
        error("unknown cue test step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("cue test step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_test .. " " .. profile.test_description)
    return beez.shell.run(ctx, cfg.log_prefix_test, command.test(cfg, ctx.project_root))
end

function M.run(ctx, step_name)
    local profile_name = defaults.run_step_profiles[step_name]
    if profile_name == nil then
        error("unknown cue run step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("cue run step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx)
    local profile = defaults.build_profiles[profile_name]
    local log_prefix = cfg.log_prefix_run or defaults.log_prefix_run or "[cue-run]"

    print(log_prefix .. " " .. (profile.run_description or "Evaluate CUE configuration"))
    return beez.shell.run(ctx, log_prefix, command.run(cfg, ctx.project_root))
end

return M
