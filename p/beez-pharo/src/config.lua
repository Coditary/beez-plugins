local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown pharo profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        image_path = cfg.image_path,
        project_root = cfg.project_root,
        source_files = cfg.source_files,
        compile_script = cfg.compile_script,
        test_script = cfg.test_script,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.pharo_binary or defaults.pharo_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        pharo_binary = cfg.pharo_binary or beez.env_or("PHARO", defaults.pharo_binary),
        squeak_binary = cfg.squeak_binary or beez.env_or("SQUEAK", defaults.squeak_binary),
        image_path = detected.image_path,
        has_image = detected.has_image,
        project_root = detected.project_root,
        source_files = detected.source_files,
        compile_script = detected.compile_script,
        test_script = detected.test_script,
        has_tests = detected.has_tests,
        build_dir = detected.build_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        test_args = cfg.test_args or profile.test_args,
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
