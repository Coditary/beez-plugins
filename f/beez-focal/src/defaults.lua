local M = {}

M.runnable = true

M.build_dir = "build/focal"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.focal_binary = "focal"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[focal-setup]"
M.log_prefix_compile = "[focal-compile]"
M.log_prefix_bundle = "[focal-bundle]"
M.log_prefix_test = "[focal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.fcl",
    "**/*.focal",
}

M.build_profiles = {
    code = {
        scope = "focal",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify FOCAL interpreter and prepare build directory",
        compile_description = "Compile FOCAL programs (*.fcl, *.focal) to listing output",
        bundle_description = "Verify FOCAL build artifacts",
        test_description = "Verify FOCAL build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "focal",
        output_name = "app",
        compile_flag = "-d",
        setup_description = "Verify FOCAL interpreter and prepare build directory (debug)",
        compile_description = "Compile FOCAL programs with debug trace output",
        bundle_description = "Verify FOCAL debug build artifacts",
        test_description = "Verify FOCAL debug build output",
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
