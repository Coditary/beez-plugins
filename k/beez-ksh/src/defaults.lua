local M = {}

M.runnable = true

M.build_dir = "build/ksh"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.ksh_binary = "ksh"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ksh-setup]"
M.log_prefix_compile = "[ksh-compile]"
M.log_prefix_bundle = "[ksh-bundle]"
M.log_prefix_test = "[ksh-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ksh",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "ksh",
        output_name = "app",
        setup_description = "Verify ksh and prepare build directory",
        compile_description = "Syntax-check ksh scripts with ksh -n",
        bundle_description = "Verify ksh compile stamp",
        test_description = "Run primary ksh script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "ksh",
        output_name = "app",
        setup_description = "Verify ksh and prepare build directory (debug)",
        compile_description = "Syntax-check ksh scripts with ksh -n (debug)",
        bundle_description = "Verify ksh debug compile stamp",
        test_description = "Run primary ksh script (verbose)",
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
