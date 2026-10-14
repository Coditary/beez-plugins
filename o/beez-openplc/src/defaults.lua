local M = {}

M.runnable = true

M.build_dir = "build/openplc"
M.bin_dir = M.build_dir .. "/bin"
M.gen_dir = M.build_dir .. "/gen"
M.reports_dir = "report"

M.openplc_binary = "openplc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[openplc-setup]"
M.log_prefix_compile = "[openplc-compile]"
M.log_prefix_bundle = "[openplc-bundle]"
M.log_prefix_test = "[openplc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.st",
    "**/*.plc",
}

M.build_profiles = {
    code = {
        scope = "openplc",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify OpenPLC IEC 61131-3 compiler and prepare build directory",
        compile_description = "Compile OpenPLC ladder/IL sources (*.st, *.plc) to C",
        bundle_description = "Verify OpenPLC build artifacts",
        test_description = "Run OpenPLC compile smoke test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "openplc",
        output_name = "app",
        compile_flags = "-v",
        setup_description = "Verify OpenPLC compiler (debug)",
        compile_description = "Compile OpenPLC sources with verbose output",
        bundle_description = "Verify OpenPLC debug build artifacts",
        test_description = "Run OpenPLC tests (verbose)",
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
