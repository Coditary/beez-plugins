local M = {}

M.runnable = true

M.build_dir = "build/jai"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.jai_binary = "jai"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jai-setup]"
M.log_prefix_compile = "[jai-compile]"
M.log_prefix_bundle = "[jai-bundle]"
M.log_prefix_test = "[jai-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.jai",
    "**/build.jai",
    "**/*.jai",
}

M.build_profiles = {
    code = {
        scope = "jai",
        output_name = "app",
        setup_description = "Verify Jai compiler binary",
        compile_description = "Compile Jai to native code",
        bundle_description = "Verify Jai build artifacts",
        test_description = "Run Jai tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Jai compiler binary (debug)",
        compile_description = "Compile Jai to native code (debug)",
        bundle_description = "Verify Jai debug artifacts",
        test_description = "Run Jai tests (verbose)",
        test_args = "-verbose",
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
