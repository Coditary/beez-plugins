local M = {}

M.runnable = true

M.build_dir = "build/a68g"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.a68g_binary = "a68g"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[a68g-setup]"
M.log_prefix_compile = "[a68g-compile]"
M.log_prefix_bundle = "[a68g-bundle]"
M.log_prefix_test = "[a68g-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.a68",
}

M.build_profiles = {
    code = {
        scope = "a68g",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify a68g ALGOL 68G compiler",
        compile_description = "Compile ALGOL 68 sources with a68g",
        bundle_description = "Verify a68g build artifacts",
        test_description = "Run a68g tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "--trace",
        setup_description = "Verify a68g compiler (debug)",
        compile_description = "Compile ALGOL 68 sources with a68g (trace)",
        bundle_description = "Verify a68g debug artifacts",
        test_description = "Run a68g tests (verbose)",
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
