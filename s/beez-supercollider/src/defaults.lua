local M = {}

M.runnable = true

M.build_dir = "build/supercollider"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.supercollider_binary = "sclang"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[supercollider-setup]"
M.log_prefix_compile = "[supercollider-compile]"
M.log_prefix_bundle = "[supercollider-bundle]"
M.log_prefix_test = "[supercollider-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.scd",
}

M.build_profiles = {
    code = {
        scope = "supercollider",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify sclang and prepare build directory",
        compile_description = "Compile supercollider sources (sclang)",
        bundle_description = "Verify supercollider compile artifacts",
        test_description = "Verify supercollider build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "supercollider",
        output_name = "app",
        compile_flag = "-V",
        setup_description = "Verify sclang and prepare build directory (debug)",
        compile_description = "Compile supercollider sources with debug flags",
        bundle_description = "Verify supercollider debug compile artifacts",
        test_description = "Verify supercollider debug build output",
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
