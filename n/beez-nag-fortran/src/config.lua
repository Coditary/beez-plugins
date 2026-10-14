local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown nag-fortran profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_marker = cfg.project_marker,
        project_root = cfg.project_root,
        targets = cfg.targets,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        cmake_dir = cfg.cmake_dir or defaults.cmake_dir,
        test_runner = cfg.test_runner,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.nagfor_binary or defaults.nagfor_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        nagfor_binary = cfg.nagfor_binary or defaults.nagfor_binary,
        project_marker = detected.project_marker,
        project_root = detected.project_root,
        build_system = detected.build_system,
        build_file = detected.build_file,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        cmake_dir = detected.cmake_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        test_runner = detected.test_runner,
        fortran_std = cfg.fortran_std or profile.fortran_std,
        optimize = cfg.optimize or profile.optimize,
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
        parallelism = cfg.parallelism or beez.env_or("NAG_PARALLEL", "0"),
    }
end

return M
