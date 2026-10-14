local M = {}

M.runnable = true

M.build_dir = "build/abap"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.abaplint_binary = "abaplint"
M.abap_binary = "abap"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[abap-setup]"
M.log_prefix_compile = "[abap-compile]"
M.log_prefix_bundle = "[abap-bundle]"
M.log_prefix_test = "[abap-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "abaplint.json",
    "**/abaplint.json",
    "**/*.abap",
}

M.build_profiles = {
    code = {
        scope = "abap",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify abaplint and abap toolchain",
        compile_description = "Run abaplint syntax check on ABAP sources",
        bundle_description = "Verify abap build artifacts",
        test_description = "Run abap tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "-v",
        setup_description = "Verify abaplint and abap toolchain (debug)",
        compile_description = "Run abaplint syntax check on ABAP sources (verbose)",
        bundle_description = "Verify abap debug artifacts",
        test_description = "Run abap tests (verbose)",
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
