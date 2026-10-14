local M = {}

M.runnable = true

M.build_dir = "build/carbon"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.carbon_binary = "carbon"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[carbon-setup]"
M.log_prefix_compile = "[carbon-compile]"
M.log_prefix_bundle = "[carbon-bundle]"
M.log_prefix_test = "[carbon-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.carbon",
}

M.build_profiles = {
    code = {
        scope = "carbon",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify carbon and prepare build directory",
        compile_description = "Compile Carbon sources (carbon)",
        bundle_description = "Verify Carbon compile artifacts",
        test_description = "Verify Carbon build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "carbon",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify carbon and prepare build directory (debug)",
        compile_description = "Compile Carbon sources with debug flags",
        bundle_description = "Verify Carbon debug compile artifacts",
        test_description = "Verify Carbon debug build output",
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
