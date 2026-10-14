local M = {}

M.runnable = true

M.build_dir = "build/curry"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.curry_binary = "curry"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[curry-setup]"
M.log_prefix_compile = "[curry-compile]"
M.log_prefix_bundle = "[curry-bundle]"
M.log_prefix_test = "[curry-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.curry",
    "**/*.lcurry",
}

M.build_profiles = {
    code = {
        scope = "curry",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify Curry compiler (PAKCS/KiCS2)",
        compile_description = "Compile Curry sources to native executable",
        bundle_description = "Verify Curry build artifacts",
        test_description = "Run Curry compile smoke test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "curry",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify Curry compiler (debug)",
        compile_description = "Compile Curry sources (debug, no optimizations)",
        bundle_description = "Verify Curry debug artifacts",
        test_description = "Run Curry tests (verbose)",
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
