local M = {}

M.runnable = true

M.build_dir = "build/factor"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.factor_binary = "factor"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[factor-setup]"
M.log_prefix_compile = "[factor-compile]"
M.log_prefix_bundle = "[factor-bundle]"
M.log_prefix_test = "[factor-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.factor",
}

M.build_profiles = {
    code = {
        scope = "factor",
        output_name = "app",
        setup_description = "Verify Factor and prepare build directory",
        compile_description = "Compile Factor sources with factor",
        bundle_description = "Verify Factor compile artifacts",
        test_description = "Run Factor tests in t/ with prove",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "factor",
        output_name = "app",
        setup_description = "Verify Factor and prepare build directory (debug)",
        compile_description = "Compile Factor sources with factor (debug)",
        bundle_description = "Verify Factor debug compile artifacts",
        test_description = "Run Factor tests in t/ with prove (verbose)",
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
