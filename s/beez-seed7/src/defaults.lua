local M = {}

M.runnable = true

M.build_dir = "build/seed7"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.seed7_binary = "s7c"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[seed7-setup]"
M.log_prefix_compile = "[seed7-compile]"
M.log_prefix_bundle = "[seed7-bundle]"
M.log_prefix_test = "[seed7-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.sd7",
    "**/*.s7i",
}

M.build_profiles = {
    code = {
        scope = "seed7",
        output_name = "app",
        compile_flag = "-O2",
        setup_description = "Verify s7c and prepare build directory",
        compile_description = "Compile seed7 sources (s7c)",
        bundle_description = "Verify seed7 compile artifacts",
        test_description = "Verify seed7 build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "seed7",
        output_name = "app",
        compile_flag = "-g",
        setup_description = "Verify s7c and prepare build directory (debug)",
        compile_description = "Compile seed7 sources with debug flags",
        bundle_description = "Verify seed7 debug compile artifacts",
        test_description = "Verify seed7 debug build output",
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
