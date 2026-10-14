local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown bazel profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        entry_source = cfg.entry_source,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        has_workspace = cfg.has_workspace,
        has_tests = cfg.has_tests,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        bazel_binary = cfg.bazel_binary or defaults.bazel_binary,
        project_root = detected.project_root,
        entry_source = detected.entry_source,
        bin_dir = detected.bin_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        build_target = cfg.build_target or profile.build_target,
        test_target = cfg.test_target or profile.test_target,
        has_workspace = detected.has_workspace,
        has_tests = detected.has_tests,
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
