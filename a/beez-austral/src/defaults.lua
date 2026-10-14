local M = {}

M.runnable = true

M.build_dir = "build/austral"
M.bin_dir = M.build_dir .. "/bin"
M.gen_dir = M.build_dir .. "/gen"
M.reports_dir = "report"

M.austral_binary = "austral"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[austral-setup]"
M.log_prefix_compile = "[austral-compile]"
M.log_prefix_bundle = "[austral-bundle]"
M.log_prefix_test = "[austral-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Module.au",
    "**/Module.au",
    "**/*.au",
}

M.build_profiles = {
    code = {
        scope = "austral",
        output_name = "app",
        setup_description = "Verify Austral compiler binary",
        compile_description = "Compile Austral to C and link native binary",
        bundle_description = "Verify Austral build artifacts",
        test_description = "Run Austral tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Austral compiler binary (debug)",
        compile_description = "Compile Austral to C (debug)",
        bundle_description = "Verify Austral debug artifacts",
        test_description = "Run Austral tests (verbose)",
        test_args = "",
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
