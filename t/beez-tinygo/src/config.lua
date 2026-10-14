local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown tinygo profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        go_mod = cfg.go_mod,
        module_root = cfg.module_root,
        targets = cfg.targets,
        bin_dir = cfg.bin_dir or profile.bin_dir,
        tinygo_target = cfg.tinygo_target or profile.tinygo_target,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.go_binary or defaults.go_binary,

        profile_name = profile_name,
        go_mod = detected.go_mod,
        go_binary = cfg.go_binary or defaults.go_binary,
        tinygo_binary = cfg.tinygo_binary or defaults.tinygo_binary,
        tinygo_target = cfg.tinygo_target or profile.tinygo_target,
        tinygo_opt = cfg.tinygo_opt or profile.tinygo_opt,
        tinygo_gc = cfg.tinygo_gc or profile.tinygo_gc,
        tinygo_size = cfg.tinygo_size or profile.tinygo_size,
        tags = cfg.tags or profile.tags,
        test_args = cfg.test_args or profile.test_args,
        test_packages = cfg.test_packages or profile.test_packages,
        module_root = detected.module_root,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        build_dir = cfg.build_dir or defaults.build_dir,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        env_prefix = "CGO_ENABLED=0",
    }
end

return M
