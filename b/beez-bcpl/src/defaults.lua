local M = {}

M.runnable = true

M.build_dir = "build/bcpl"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.bcpl_binary = "bcpl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bcpl-setup]"
M.log_prefix_compile = "[bcpl-compile]"
M.log_prefix_bundle = "[bcpl-bundle]"
M.log_prefix_test = "[bcpl-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.b",
}

M.build_profiles = {
    code = {
        scope = "bcpl",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify bcpl and prepare build directory",
        compile_description = "Compile BCPL sources (bcpl)",
        bundle_description = "Verify BCPL compile artifacts",
        test_description = "Verify BCPL build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "bcpl",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify bcpl and prepare build directory (debug)",
        compile_description = "Compile BCPL sources with debug flags",
        bundle_description = "Verify BCPL debug compile artifacts",
        test_description = "Verify BCPL debug build output",
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
