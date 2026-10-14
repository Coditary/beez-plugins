local M = {}

M.runnable = true

M.build_dir = "build/kivy"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.python_binary = "python3"
M.pip_binary = "pip3"
M.pytest_binary = "pytest"
M.kivy_headless = "1"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[kivy-setup]"
M.log_prefix_compile = "[kivy-compile]"
M.log_prefix_bundle = "[kivy-bundle]"
M.log_prefix_test = "[kivy-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.kv",
    "pyproject.toml",
    "**/pyproject.toml",
    "requirements.txt",
    "**/requirements.txt",
    "**/*.py",
}

M.compile_exclude = [[/(\.git|__pycache__|build|\.venv|venv|\.tox|\.mypy_cache)/]]

M.build_profiles = {
    code = {
        scope = "kivy",
        output_name = "app",
        optimize = 0,
        setup_description = "Install Kivy and Python dependencies with pip",
        compile_description = "Validate .kv files and compile Python sources (headless)",
        bundle_description = "Verify Kivy bytecode artifacts",
        test_description = "Run Kivy tests with pytest (headless)",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "kivy",
        output_name = "app",
        optimize = 0,
        setup_description = "Install Kivy and Python dependencies with pip (debug)",
        compile_description = "Validate .kv files and compile Python sources (headless, debug)",
        bundle_description = "Verify Kivy debug bytecode artifacts",
        test_description = "Run Kivy tests with pytest (headless, verbose)",
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
