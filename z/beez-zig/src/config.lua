local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown zig profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        build_zig = cfg.build_zig,
        build_zig_zon = cfg.build_zig_zon,
        project_root = cfg.project_root,
        sources = cfg.sources,
        binary_name = cfg.binary_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.zig_binary or defaults.zig_binary,

        profile_name = profile_name,
        scope = profile.scope,
        optimize = cfg.optimize or profile.optimize,
        zig_binary = cfg.zig_binary or defaults.zig_binary,
        build_zig = detected.build_zig,
        build_zig_zon = detected.build_zig_zon,
        project_root = detected.project_root,
        sources = detected.sources,
        binary_name = detected.binary_name,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        has_zon = detected.has_zon,
        build_dir = cfg.build_dir or defaults.build_dir,
        cache_dir = cfg.cache_dir or defaults.cache_dir,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
