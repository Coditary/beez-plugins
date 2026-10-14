local M = {}

M.runnable = true

M.build_dir = "build/chill"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.chill_binary = "chill"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[chill-setup]"
M.log_prefix_compile = "[chill-compile]"
M.log_prefix_bundle = "[chill-bundle]"
M.log_prefix_test = "[chill-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ch",
}

M.build_profiles = {
    code = {
        scope = "chill",
        output_name = "app",
        compile_flag = "-O2",
        setup_description = "Verify chill and prepare build directory",
        compile_description = "Compile CHILL sources (chill)",
        bundle_description = "Verify CHILL compile artifacts",
        test_description = "Verify CHILL build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "chill",
        output_name = "app",
        compile_flag = "-g",
        setup_description = "Verify chill and prepare build directory (debug)",
        compile_description = "Compile CHILL sources with debug flags",
        bundle_description = "Verify CHILL debug compile artifacts",
        test_description = "Verify CHILL debug build output",
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
