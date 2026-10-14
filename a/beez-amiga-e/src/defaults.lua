local M = {}

M.runnable = true

M.build_dir = "build/amiga-e"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ec_binary = "ec"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[amiga-e-setup]"
M.log_prefix_compile = "[amiga-e-compile]"
M.log_prefix_bundle = "[amiga-e-bundle]"
M.log_prefix_test = "[amiga-e-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.e",
}

M.build_profiles = {
    code = {
        scope = "amiga-e",
        output_name = "app",
        setup_description = "Verify Amiga E compiler (ec, 68000)",
        compile_description = "Compile Amiga E to 68000 executable",
        bundle_description = "Verify Amiga E build artifacts",
        test_description = "Run Amiga E tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Amiga E compiler (debug)",
        compile_description = "Compile Amiga E to 68000 executable (debug)",
        bundle_description = "Verify Amiga E debug artifacts",
        test_description = "Run Amiga E tests (verbose)",
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
