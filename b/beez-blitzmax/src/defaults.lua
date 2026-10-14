local M = {}

M.runnable = true

M.build_dir = "build/blitzmax"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.bmk_binary = "bmk"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[blitzmax-setup]"
M.log_prefix_compile = "[blitzmax-compile]"
M.log_prefix_bundle = "[blitzmax-bundle]"
M.log_prefix_test = "[blitzmax-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bmx",
}

M.build_profiles = {
    code = {
        scope = "blitzmax",
        output_name = "app",
        build_mode = "-r",
        setup_description = "Verify BlitzMax Make (bmk) compiler",
        compile_description = "Compile BlitzMax application via bmk makeapp",
        bundle_description = "Verify BlitzMax build artifacts",
        test_description = "Run BlitzMax tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        build_mode = "-d",
        setup_description = "Verify BlitzMax Make (bmk) compiler (debug)",
        compile_description = "Compile BlitzMax application (debug)",
        bundle_description = "Verify BlitzMax debug artifacts",
        test_description = "Run BlitzMax tests (verbose)",
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
