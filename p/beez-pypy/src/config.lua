local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown pypy profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        pyproject_path = cfg.pyproject_path,
        requirements_path = cfg.requirements_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.pypy_binary or defaults.pypy_binary,

        profile_name = profile_name,
        scope = profile.scope,
        optimize = cfg.optimize or profile.optimize,
        pypy_binary = cfg.pypy_binary or beez.env_or("PYPY", defaults.pypy_binary),
        pypy_fallback_binary = cfg.pypy_fallback_binary or defaults.pypy_fallback_binary,
        pytest_binary = cfg.pytest_binary or defaults.pytest_binary,
        pyproject_path = detected.pyproject_path,
        requirements_path = detected.requirements_path,
        has_pyproject = detected.has_pyproject,
        has_requirements = detected.has_requirements,
        has_installable = detected.has_installable,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        compile_exclude = cfg.compile_exclude or defaults.compile_exclude,
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
