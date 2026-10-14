local M = {}

M.runnable = true

M.build_dir = "build/es"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.es_binary = "es"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[es-setup]"
M.log_prefix_compile = "[es-compile]"
M.log_prefix_bundle = "[es-bundle]"
M.log_prefix_test = "[es-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.es",
}

M.build_profiles = {
    code = {
        scope = "es",
        output_name = "app",
        setup_description = "Verify es and prepare build directory",
        compile_description = "Parse-check es scripts with es -e",
        bundle_description = "Verify es compile stamp",
        test_description = "Run primary es script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "es",
        output_name = "app",
        setup_description = "Verify es and prepare build directory (debug)",
        compile_description = "Parse-check es scripts with es -e (debug)",
        bundle_description = "Verify es debug compile stamp",
        test_description = "Run primary es script (verbose)",
        test_args = "-x",
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
