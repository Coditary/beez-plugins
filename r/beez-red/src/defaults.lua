local M = {}

M.runnable = true

M.build_dir = "build/red"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.red_binary = "red"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[red-setup]"
M.log_prefix_compile = "[red-compile]"
M.log_prefix_bundle = "[red-bundle]"
M.log_prefix_test = "[red-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.red",
}

M.build_profiles = {
    code = {
        scope = "red",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify red and prepare build directory",
        compile_description = "Compile red sources (red)",
        bundle_description = "Verify red compile artifacts",
        test_description = "Verify red build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "red",
        output_name = "app",
        compile_flag = "-d",
        setup_description = "Verify red and prepare build directory (debug)",
        compile_description = "Compile red sources with debug flags",
        bundle_description = "Verify red debug compile artifacts",
        test_description = "Verify red debug build output",
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
