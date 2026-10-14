local M = {}

M.runnable = true

M.build_dir = "build/chapel"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.chapel_binary = "chpl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[chapel-setup]"
M.log_prefix_compile = "[chapel-compile]"
M.log_prefix_bundle = "[chapel-bundle]"
M.log_prefix_test = "[chapel-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.chpl",
    "Chapel.toml",
    "**/Chapel.toml",
}

M.build_profiles = {
    code = {
        scope = "chapel",
        output_name = "app",
        compile_flag = "-O",
        setup_description = "Verify chpl and prepare build directory",
        compile_description = "Compile Chapel sources (chpl)",
        bundle_description = "Verify Chapel compile artifacts",
        test_description = "Verify Chapel build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "chapel",
        output_name = "app",
        compile_flag = "-g",
        setup_description = "Verify chpl and prepare build directory (debug)",
        compile_description = "Compile Chapel sources with debug flags",
        bundle_description = "Verify Chapel debug compile artifacts",
        test_description = "Verify Chapel debug build output",
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
