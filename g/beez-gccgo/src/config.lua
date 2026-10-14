local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown gccgo profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        go_mod = cfg.go_mod,
        module_root = cfg.module_root,
        targets = cfg.targets,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.go_binary or defaults.go_binary,

        profile_name = profile_name,
        go_binary = cfg.go_binary or defaults.go_binary,
        gccgo_binary = cfg.gccgo_binary or defaults.gccgo_binary,
        use_go_frontend = cfg.use_go_frontend ~= nil and cfg.use_go_frontend or profile.use_go_frontend,
        gccgo_optimize = cfg.gccgo_optimize ~= nil and cfg.gccgo_optimize or profile.gccgo_optimize,
        cgo_enabled = cfg.cgo_enabled or profile.cgo_enabled,
        ldflags = cfg.ldflags or profile.ldflags,
        tags = cfg.tags or profile.tags,
        test_args = cfg.test_args or profile.test_args,
        test_packages = cfg.test_packages or profile.test_packages,
        module_root = detected.module_root,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        build_dir = cfg.build_dir or defaults.build_dir,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        env_prefix = "CGO_ENABLED=" .. beez.char.quote(cfg.cgo_enabled or profile.cgo_enabled),
    }
end

return M
