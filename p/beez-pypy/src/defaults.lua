local M = {}

M.runnable = true

M.build_dir = "build/pypy"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.pypy_binary = "pypy3"
M.pypy_fallback_binary = "pypy"
M.pytest_binary = "pytest"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pypy-setup]"
M.log_prefix_compile = "[pypy-compile]"
M.log_prefix_bundle = "[pypy-bundle]"
M.log_prefix_test = "[pypy-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pyproject.toml",
    "**/pyproject.toml",
    "requirements.txt",
    "**/requirements.txt",
    "**/*.py",
}

M.compile_exclude = [[/(\.git|__pycache__|build|\.venv|venv|\.tox|\.mypy_cache)/]]

M.build_profiles = {
    code = {
        scope = "pypy",
        output_name = "app",
        optimize = 0,
        setup_description = "Install Python dependencies with pypy -m pip",
        compile_description = "Compile Python sources to bytecode with pypy -m compileall",
        bundle_description = "Verify PyPy bytecode artifacts",
        test_description = "Run Python tests with pypy -m pytest",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "pypy",
        output_name = "app",
        optimize = 0,
        setup_description = "Install Python dependencies with pypy -m pip (debug)",
        compile_description = "Compile Python sources to bytecode with pypy -m compileall (debug)",
        bundle_description = "Verify PyPy debug bytecode artifacts",
        test_description = "Run Python tests with pypy -m pytest (verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
