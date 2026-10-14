local M = {}

M.runnable = true

M.build_dir = "build/cython"
M.lib_dir = M.build_dir .. "/lib"
M.temp_dir = M.build_dir .. "/temp"
M.reports_dir = "report"

M.cython_binary = "cython"
M.python_binary = "python"
M.pip_binary = "pip"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cython-setup]"
M.log_prefix_compile = "[cython-compile]"
M.log_prefix_bundle = "[cython-bundle]"
M.log_prefix_test = "[cython-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "setup.py",
    "**/setup.py",
    "pyproject.toml",
    "**/pyproject.toml",
    "**/*.pyx",
    "**/*.py",
}

M.build_profiles = {
    code = {
        scope = "cython",
        build_mode = "release",
        setup_description = "Install Cython build dependencies with pip",
        compile_description = "Compile Cython extensions with python setup.py build_ext (release)",
        bundle_description = "Verify Cython extension artifacts",
        test_description = "Run Cython project tests with pytest",
        build_ext_args = "",
        cython_args = "-3",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "cython",
        build_mode = "debug",
        setup_description = "Install Cython build dependencies with pip (debug)",
        compile_description = "Compile Cython extensions with python setup.py build_ext (debug)",
        bundle_description = "Verify Cython debug extension artifacts",
        test_description = "Run Cython project tests with pytest (verbose)",
        build_ext_args = "--inplace",
        cython_args = "-3 --gdb",
        test_args = "-v",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["cython:configure"] = "code",
    ["cython:configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["cython:compile"] = "code",
    ["cython:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["cython:bundle"] = "code",
    ["cython:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["cython:test"] = "code",
    ["cython:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["cython:run"] = "code",
    ["cython:run:debug"] = "debug",
}

return M
