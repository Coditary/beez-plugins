local M = {}

M.runnable = true

M.build_dir = "build/qbasic"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.qb64_binary = "qb64"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[qbasic-setup]"
M.log_prefix_compile = "[qbasic-compile]"
M.log_prefix_bundle = "[qbasic-bundle]"
M.log_prefix_test = "[qbasic-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bas",
}

M.build_profiles = {
    code = {
        scope = "qbasic",
        output_name = "app",
        compile_flags = "-c",
        setup_description = "Verify qb64 QuickBASIC compiler",
        compile_description = "Compile BASIC sources with qb64",
        bundle_description = "Verify qbasic build artifacts",
        test_description = "Run qbasic tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "-c -g",
        setup_description = "Verify qb64 QuickBASIC compiler (debug)",
        compile_description = "Compile BASIC sources with qb64 (debug)",
        bundle_description = "Verify qbasic debug artifacts",
        test_description = "Run qbasic tests (verbose)",
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
