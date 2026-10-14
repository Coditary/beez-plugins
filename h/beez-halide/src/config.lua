local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown halide profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        manifest_path = cfg.manifest_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        cxx_binary = cfg.cxx_binary or beez.env_or("CXX", defaults.cxx_binary),
        halide_generator_binary = cfg.halide_generator_binary or beez.env_or("HALIDE_GENERATOR", defaults.halide_generator_binary),
        manifest_path = detected.manifest_path,
        has_manifest = detected.has_manifest,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        has_test_dir = detected.has_test_dir,
        test_dir = detected.test_dir,
        compile_stamp = detected.bin_dir .. "/.halide-compile-" .. profile_name,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
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
