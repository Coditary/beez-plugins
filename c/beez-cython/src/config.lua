local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown cython profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        setup_py_path = cfg.setup_py_path,
        pyproject_path = cfg.pyproject_path,
        project_root = cfg.project_root,
        package_name = cfg.package_name,
        lib_dir = cfg.lib_dir or defaults.lib_dir,
        temp_dir = cfg.temp_dir or defaults.temp_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.python_binary or defaults.python_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        cython_binary = cfg.cython_binary or defaults.cython_binary,
        python_binary = cfg.python_binary or defaults.python_binary,
        pip_binary = cfg.pip_binary or defaults.pip_binary,
        setup_py_path = detected.setup_py_path,
        pyproject_path = detected.pyproject_path,
        has_setup_py = detected.has_setup_py,
        has_pyproject = detected.has_pyproject,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        lib_dir = detected.lib_dir,
        temp_dir = detected.temp_dir,
        primary_source = detected.primary_source,
        build_ext_args = cfg.build_ext_args or profile.build_ext_args,
        cython_args = cfg.cython_args or profile.cython_args,
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
