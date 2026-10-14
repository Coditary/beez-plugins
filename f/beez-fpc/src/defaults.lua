local M = {}

M.runnable = true

M.build_dir = "build/fpc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.fpc_binary = "fpc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fpc-setup]"
M.log_prefix_compile = "[fpc-compile]"
M.log_prefix_bundle = "[fpc-bundle]"
M.log_prefix_test = "[fpc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.lpi",
    "*.dpr",
    "*.pas",
    "**/*.pas",
}

M.build_profiles = {
    code = {
        scope = "fpc",
        build_mode = "release",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Prepare Free Pascal build environment",
        compile_description = "Build with FPC (release, -O2)",
        bundle_description = "Verify FPC build artifacts",
        test_description = "Run Pascal tests with FPC",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        optimize = "-g -Ci",
        setup_description = "Prepare Free Pascal build environment (debug)",
        compile_description = "Build with FPC (debug, -g -Ci)",
        bundle_description = "Verify FPC debug build artifacts",
        test_description = "Run Pascal tests with FPC (verbose)",
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
