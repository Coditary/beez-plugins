local M = {}

M.runnable = true

M.build_dir = "build/zonnon"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.zonnon_binary = "ncc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[zonnon-setup]"
M.log_prefix_compile = "[zonnon-compile]"
M.log_prefix_bundle = "[zonnon-bundle]"
M.log_prefix_test = "[zonnon-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.zonnon",
}

M.build_profiles = {
    code = {
        scope = "zonnon",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify ncc and prepare build directory",
        compile_description = "Compile zonnon sources (ncc)",
        bundle_description = "Verify zonnon compile artifacts",
        test_description = "Verify zonnon build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "zonnon",
        output_name = "app",
        compile_flag = "-debug",
        setup_description = "Verify ncc and prepare build directory (debug)",
        compile_description = "Compile zonnon sources with debug flags",
        bundle_description = "Verify zonnon debug compile artifacts",
        test_description = "Verify zonnon debug build output",
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
