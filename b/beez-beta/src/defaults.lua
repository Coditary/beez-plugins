local M = {}

M.runnable = true

M.build_dir = "build/beta"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.beta_binary = "beta"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[beta-setup]"
M.log_prefix_compile = "[beta-compile]"
M.log_prefix_bundle = "[beta-bundle]"
M.log_prefix_test = "[beta-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bet",
}

M.compile_exclude = [[/(\.git|build|\.venv|local|target|_build)/]]

M.build_profiles = {
    code = {
        scope = "beta",
        output_name = "app",
        setup_description = "Verify beta and prepare build directory",
        compile_description = "Compile/type-check beta sources",
        bundle_description = "Verify beta compile stamp",
        test_description = "Run beta tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "beta",
        output_name = "app",
        setup_description = "Verify beta and prepare build directory (debug)",
        compile_description = "Compile/type-check beta sources (debug)",
        bundle_description = "Verify beta debug compile stamp",
        test_description = "Run beta tests (verbose)",
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
