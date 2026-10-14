local M = {}

M.runnable = true

M.build_dir = "build/io"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.io_binary = "io"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[io-setup]"
M.log_prefix_compile = "[io-compile]"
M.log_prefix_bundle = "[io-bundle]"
M.log_prefix_test = "[io-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.io",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "io",
        output_name = "app",
        setup_description = "Verify io and prepare build directory",
        compile_description = "Load and validate Io sources with io",
        bundle_description = "Verify io compile stamp",
        test_description = "Run primary Io script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "io",
        output_name = "app",
        setup_description = "Verify io and prepare build directory (debug)",
        compile_description = "Load and validate Io sources with io (debug)",
        bundle_description = "Verify io debug compile stamp",
        test_description = "Run primary Io script (verbose)",
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
