local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown tectonic profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        out_dir = cfg.out_dir or defaults.out_dir,
        entry_source = cfg.entry_source,
        tectonic_toml = cfg.tectonic_toml,
        has_tests = cfg.has_tests,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        tectonic_binary = cfg.tectonic_binary or defaults.tectonic_binary,
        project_root = detected.project_root,
        entry_source = detected.entry_source,
        tectonic_toml = detected.tectonic_toml,
        has_tectonic_toml = detected.has_tectonic_toml,
        out_dir = detected.out_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        has_tests = detected.has_tests,
        compile_args = cfg.compile_args or profile.compile_args,
        compile_passes = cfg.compile_passes or profile.compile_passes,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        build_dir = cfg.build_dir or defaults.build_dir,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
