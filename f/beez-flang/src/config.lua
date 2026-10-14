local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown flang profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_marker = cfg.project_marker,
        project_root = cfg.project_root,
        targets = cfg.targets,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        test_runner = cfg.test_runner,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.flang_binary or defaults.flang_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        flang_binary = cfg.flang_binary or defaults.flang_binary,
        flang_binary_fallback = cfg.flang_binary_fallback or defaults.flang_binary_fallback,
        project_marker = detected.project_marker,
        project_root = detected.project_root,
        build_system = detected.build_system,
        build_marker = detected.build_marker,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        test_runner = detected.test_runner,
        optimize = cfg.optimize or profile.optimize,
        debug_flags = cfg.debug_flags or profile.debug_flags,
        cmake_build_type = cfg.cmake_build_type or profile.cmake_build_type,
        cmake_dir = cfg.cmake_dir or defaults.cmake_dir,
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
        parallelism = cfg.parallelism or beez.env_or("FLANG_PARALLEL", beez.env_or("CMAKE_BUILD_PARALLEL_LEVEL", "0")),
    }
end

return M
