local M = {}

M.runnable = true

M.build_dir = "build/bc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.bc_binary = "bc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bc-setup]"
M.log_prefix_compile = "[bc-compile]"
M.log_prefix_bundle = "[bc-bundle]"
M.log_prefix_test = "[bc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bc",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "bc",
        output_name = "app",
        setup_description = "Verify bc and prepare build directory",
        compile_description = "Parse bc calculator sources with bc -q",
        bundle_description = "Verify bc compile stamp",
        test_description = "Evaluate primary bc script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "bc",
        output_name = "app",
        setup_description = "Verify bc and prepare build directory (debug)",
        compile_description = "Parse bc calculator sources with bc -q (debug)",
        bundle_description = "Verify bc debug compile stamp",
        test_description = "Evaluate primary bc script (verbose)",
        test_args = "-w",
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
