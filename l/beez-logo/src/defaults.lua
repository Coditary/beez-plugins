local M = {}

M.runnable = true

M.build_dir = "build/logo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.logo_binary = "logo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[logo-setup]"
M.log_prefix_compile = "[logo-compile]"
M.log_prefix_bundle = "[logo-bundle]"
M.log_prefix_test = "[logo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.logo",
    "**/*.lgo",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "logo",
        output_name = "app",
        setup_description = "Verify UCBLogo and prepare build directory",
        compile_description = "Run Logo sources in batch mode (logo -g -b)",
        bundle_description = "Verify logo compile stamp",
        test_description = "Run primary Logo script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "logo",
        output_name = "app",
        setup_description = "Verify UCBLogo and prepare build directory (debug)",
        compile_description = "Run Logo sources in batch mode (logo -g -b, debug)",
        bundle_description = "Verify logo debug compile stamp",
        test_description = "Run primary Logo script (verbose)",
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
