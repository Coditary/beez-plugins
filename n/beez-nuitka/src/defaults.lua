local M = {}

M.runnable = true

M.build_dir = "build/nuitka"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.nuitka_binary = "nuitka"
M.python_binary = "python3"
M.pip_binary = "pip"
M.use_module = true
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nuitka-setup]"
M.log_prefix_compile = "[nuitka-compile]"
M.log_prefix_bundle = "[nuitka-bundle]"
M.log_prefix_test = "[nuitka-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pyproject.toml",
    "**/pyproject.toml",
    "**/*.py",
}

M.build_profiles = {
    code = {
        scope = "nuitka",
        standalone = true,
        debug = false,
        output_name = "app",
        setup_description = "Install Python dependencies and Nuitka",
        compile_description = "Compile Python to native code with Nuitka (--standalone)",
        bundle_description = "Verify Nuitka standalone build artifacts",
        test_description = "Run Python tests with pytest",
        test_args = "",
        nuitka_args = { "--assume-yes-for-downloads" },
    },

    debug = {
        scope = "nuitka",
        standalone = true,
        debug = true,
        output_name = "app",
        setup_description = "Install Python dependencies and Nuitka (debug)",
        compile_description = "Compile Python to native code with Nuitka (--standalone --debug)",
        bundle_description = "Verify Nuitka debug standalone artifacts",
        test_description = "Run Python tests with pytest (verbose)",
        test_args = "-v",
        nuitka_args = { "--assume-yes-for-downloads", "--debug" },
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
