local M = {}

M.runnable = true

M.build_dir = "build/parrot"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.parrot_binary = "parrot"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[parrot-setup]"
M.log_prefix_compile = "[parrot-compile]"
M.log_prefix_bundle = "[parrot-bundle]"
M.log_prefix_test = "[parrot-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.pir",
    "**/*.pasm",
    "**/*.pbc",
}

M.build_profiles = {
    code = {
        scope = "parrot",
        output_name = "app",
        setup_description = "Verify parrot binary and prepare build directory",
        compile_description = "Compile PIR/PASM sources to Parrot bytecode (.pbc)",
        bundle_description = "Verify Parrot bytecode artifacts",
        test_description = "Run Parrot tests in t/ with prove",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "parrot",
        output_name = "app",
        setup_description = "Verify parrot binary and prepare build directory (debug)",
        compile_description = "Compile PIR/PASM sources to Parrot bytecode (.pbc, debug)",
        bundle_description = "Verify Parrot debug bytecode artifacts",
        test_description = "Run Parrot tests in t/ with prove (verbose)",
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
