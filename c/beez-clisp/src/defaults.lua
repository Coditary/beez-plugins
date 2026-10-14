local M = {}

M.runnable = true

M.build_dir = "build/clisp"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.clisp_binary = "clisp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[clisp-setup]"
M.log_prefix_compile = "[clisp-compile]"
M.log_prefix_bundle = "[clisp-bundle]"
M.log_prefix_test = "[clisp-test]"
M.log_prefix_run = "[clisp-run]"

M.common_inputs = {
    "**/*.lisp",
    "**/*.lsp",
    "**/*.cl"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Clisp runtime and prepare build directory",
        compile_description = "Validate Clisp entry with clisp",
        bundle_description = "Verify Clisp compile stamp",
        test_description = "Run primary Clisp entry",
        test_args = "",
        run_description = "Run Clisp application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Clisp runtime (debug)",
        compile_description = "Validate Clisp entry with clisp (debug)",
        bundle_description = "Verify Clisp debug compile stamp",
        test_description = "Run primary Clisp entry (verbose)",
        test_args = "",
        run_description = "Run Clisp application (debug)",
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
