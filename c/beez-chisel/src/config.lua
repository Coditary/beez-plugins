local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown chisel profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        build_sbt = cfg.build_sbt,
        project_root = cfg.project_root,
        sources = cfg.sources,
        output_name = cfg.output_name or profile.output_name,
        classes_dir = cfg.classes_dir or defaults.classes_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        has_tests = cfg.has_tests,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        sbt_binary = cfg.sbt_binary or defaults.sbt_binary,
        build_sbt = detected.build_sbt,
        has_build_sbt = detected.has_build_sbt,
        project_root = detected.project_root,
        sources = detected.sources,
        classes_dir = detected.classes_dir,
        bin_dir = detected.bin_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        classes_output = detected.classes_output,
        has_tests = detected.has_tests,
        sbt_compile_task = cfg.sbt_compile_task or profile.sbt_compile_task,
        sbt_test_task = cfg.sbt_test_task or profile.sbt_test_task,
        test_args = cfg.test_args or profile.test_args,
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
