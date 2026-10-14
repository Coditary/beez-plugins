local M = {}

M.runnable = true

M.build_dir = "build/dynamo"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.dynamo_binary = "dynamo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dynamo-setup]"
M.log_prefix_compile = "[dynamo-compile]"
M.log_prefix_bundle = "[dynamo-bundle]"
M.log_prefix_test = "[dynamo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.dym",
    "**/*.dyn",
}

M.build_profiles = {
    code = {
        scope = "dynamo",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify DYNAMO simulation compiler and prepare build directory",
        compile_description = "Compile DYNAMO simulation models (*.dym, *.dyn)",
        bundle_description = "Verify DYNAMO build artifacts",
        test_description = "Verify DYNAMO build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "dynamo",
        output_name = "app",
        compile_flag = "-d",
        setup_description = "Verify DYNAMO compiler and prepare build directory (debug)",
        compile_description = "Compile DYNAMO models with debug listing output",
        bundle_description = "Verify DYNAMO debug build artifacts",
        test_description = "Verify DYNAMO debug build output",
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
