local M = {}

M.runnable = true

M.build_dir = "build/clean"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.clean_binary = "clm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[clean-setup]"
M.log_prefix_compile = "[clean-compile]"
M.log_prefix_bundle = "[clean-bundle]"
M.log_prefix_test = "[clean-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.icl",
}

M.build_profiles = {
    code = {
        scope = "clean",
        output_name = "app",
        compile_flag = "-O",
        setup_description = "Verify clm and prepare build directory",
        compile_description = "Compile Clean sources (clm)",
        bundle_description = "Verify Clean compile artifacts",
        test_description = "Verify Clean build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "clean",
        output_name = "app",
        compile_flag = "-g",
        setup_description = "Verify clm and prepare build directory (debug)",
        compile_description = "Compile Clean sources with debug flags",
        bundle_description = "Verify Clean debug compile artifacts",
        test_description = "Verify Clean debug build output",
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
