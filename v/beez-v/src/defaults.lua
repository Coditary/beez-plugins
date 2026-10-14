local M = {}

M.runnable = true

M.build_dir = "build/v"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.v_binary = "v"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[v-setup]"
M.log_prefix_compile = "[v-compile]"
M.log_prefix_bundle = "[v-bundle]"
M.log_prefix_test = "[v-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "v.mod",
    "**/v.mod",
    "**/*.v",
}

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        setup_description = "Verify V compiler binary",
        compile_description = "Compile V to native code",
        bundle_description = "Verify V build artifacts",
        test_description = "Run V tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify V compiler binary (debug)",
        compile_description = "Compile V to native code (debug)",
        bundle_description = "Verify V debug artifacts",
        test_description = "Run V tests (verbose)",
        test_args = "-stats",
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
