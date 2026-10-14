local config = require("src.config")
local command = require("src.command")
local defaults = require("src.defaults")
local shell = require("src.shell")

local M = {}

local function resolve_step_config(ctx)
    local from_context = ctx.get_config()
    if from_context ~= nil then
        return from_context
    end

    return require("src.step_config").report_defaults()
end

function M.report(ctx)
    local step_cfg = resolve_step_config(ctx)
    local cfg = config.resolve(step_cfg)
    local root = ctx.project_root

    print(cfg.log_prefix .. " generating HTML coverage report (min " ..
        cfg.min_line_coverage .. "% line coverage)")
    return shell.run(ctx, cfg.log_prefix, command.report(cfg, root))
end

return M
