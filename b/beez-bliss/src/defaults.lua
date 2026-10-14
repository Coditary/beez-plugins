local M = {}

M.runnable = true

M.build_dir = "build/bliss"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.bliss_binary = "bliss"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bliss-setup]"
M.log_prefix_compile = "[bliss-compile]"
M.log_prefix_bundle = "[bliss-bundle]"
M.log_prefix_test = "[bliss-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bli",
}

M.build_profiles = {
    code = {
        scope = "bliss",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify bliss and prepare build directory",
        compile_description = "Compile BLISS sources (bliss)",
        bundle_description = "Verify BLISS compile artifacts",
        test_description = "Verify BLISS build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "bliss",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify bliss and prepare build directory (debug)",
        compile_description = "Compile BLISS sources with debug flags",
        bundle_description = "Verify BLISS debug compile artifacts",
        test_description = "Verify BLISS debug build output",
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
