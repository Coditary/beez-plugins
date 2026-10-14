local M = {}

M.runnable = true

M.build_dir = "build/eiffel"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.eiffel_binary = "ec"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[eiffel-setup]"
M.log_prefix_compile = "[eiffel-compile]"
M.log_prefix_bundle = "[eiffel-bundle]"
M.log_prefix_test = "[eiffel-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.e",
    "*.ecf",
    "**/*.ecf",
}

M.build_profiles = {
    code = {
        scope = "eiffel",
        output_name = "app",
        setup_description = "Verify ISE EiffelStudio and prepare build directory",
        compile_description = "Compile Eiffel sources with ec",
        bundle_description = "Verify Eiffel compile artifacts",
        test_description = "Run Eiffel tests in t/ with prove",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "eiffel",
        output_name = "app",
        setup_description = "Verify ISE EiffelStudio and prepare build directory (debug)",
        compile_description = "Compile Eiffel sources with ec (debug)",
        bundle_description = "Verify Eiffel debug compile artifacts",
        test_description = "Run Eiffel tests in t/ with prove (verbose)",
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
