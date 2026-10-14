local M = {}

M.runnable = true

M.build_dir = "build/xojo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.xojo_binary = "xojo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[xojo-setup]"
M.log_prefix_compile = "[xojo-compile]"
M.log_prefix_bundle = "[xojo-bundle]"
M.log_prefix_test = "[xojo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.xojo_code",
    "*.xojo_project",
    "**/*.xojo_project",
}

M.build_profiles = {
    code = {
        scope = "xojo",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify xojo and prepare build directory",
        compile_description = "Compile xojo sources (xojo)",
        bundle_description = "Verify xojo compile artifacts",
        test_description = "Verify xojo build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "xojo",
        output_name = "app",
        compile_flag = "--debug",
        setup_description = "Verify xojo and prepare build directory (debug)",
        compile_description = "Compile xojo sources with debug flags",
        bundle_description = "Verify xojo debug compile artifacts",
        test_description = "Verify xojo debug build output",
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
