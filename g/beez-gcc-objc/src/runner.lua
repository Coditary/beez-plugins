local command = require("src.command")
local config = require("src.config")
local compdb = require("src.compdb")
local compile = require("src.compile")
local defaults = require("src.defaults")
local link = require("src.link")

local M = {}

function M.setup(ctx, step_name)
    local profile_name = defaults.configure_step_profiles[step_name]
    if profile_name == nil then
        error("unknown gcc-objc setup step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("gcc-objc setup step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx.project_root)
    print(cfg.log_prefix_setup .. " " .. cfg.setup_description)
    return beez.shell.run(ctx, cfg.log_prefix_setup, command.setup(cfg, ctx.project_root))
end

function M.compile(ctx, step_name)
    local profile_name = defaults.compile_step_profiles[step_name]
    if profile_name == nil then
        error("unknown gcc-objc compile step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("gcc-objc compile step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx.project_root)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_compile .. " " .. profile.compile_description)

    local index, code = compdb.load_index(cfg, ctx.project_root, ctx, cfg.log_prefix_compile)
    if index == nil then
        return code
    end

    return compile.run(ctx, cfg, index)
end

function M.link(ctx, step_name)
    local profile_name = defaults.link_step_profiles[step_name]
    if profile_name == nil then
        error("unknown gcc-objc link step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("gcc-objc link step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx.project_root)
    local profile = defaults.build_profiles[profile_name]

    print(cfg.log_prefix_link .. " " .. profile.link_description)

    local index, code = compdb.load_index(cfg, ctx.project_root, ctx, cfg.log_prefix_link)
    if index == nil then
        return code
    end

    return link.run(ctx, cfg, profile, index, ctx.project_root)
end

function M.test(ctx, step_name)
    local profile_name = defaults.test_step_profiles[step_name]
    if profile_name == nil then
        error("unknown gcc-objc test step: " .. tostring(step_name))
    end

    local step_cfg = ctx.get_config()
    if step_cfg == nil then
        error("gcc-objc test step config is missing")
    end

    local cfg = config.resolve(step_cfg, profile_name, ctx.project_root)
    print(cfg.log_prefix_test .. " " .. cfg.test_description)
    return beez.shell.run(ctx, cfg.log_prefix_test, command.test(cfg, ctx.project_root))
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

    local cfg = config.resolve(step_cfg, profile_name, ctx.project_root)
    local profile = defaults.build_profiles[profile_name]
    local log_prefix = cfg.log_prefix_run or defaults.log_prefix_run or "[run]"

    print(log_prefix .. " " .. (profile.run_description or "Run application"))
    return beez.shell.run(ctx, log_prefix, command.run(cfg, ctx.project_root))
end

return M
