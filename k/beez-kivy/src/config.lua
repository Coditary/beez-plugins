local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown kivy profile: " .. tostring(profile_name))
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
        interpreter_binary = cfg.interpreter_binary or cfg.python_binary or defaults.python_binary,

        profile_name = profile_name,
        scope = profile.scope,
        optimize = cfg.optimize or profile.optimize,
        python_binary = cfg.python_binary or beez.env_or("PYTHON", defaults.python_binary),
        pip_binary = cfg.pip_binary or beez.env_or("PIP", defaults.pip_binary),
        pytest_binary = cfg.pytest_binary or defaults.pytest_binary,
        kivy_headless = cfg.kivy_headless or beez.env_or("KIVY_HEADLESS", defaults.kivy_headless),
        pyproject_path = detected.pyproject_path,
        requirements_path = detected.requirements_path,
        has_pyproject = detected.has_pyproject,
        has_requirements = detected.has_requirements,
        has_installable = detected.has_installable,
        kv_files = detected.kv_files,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_kv = detected.primary_kv,
        primary_py = detected.primary_py,
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
