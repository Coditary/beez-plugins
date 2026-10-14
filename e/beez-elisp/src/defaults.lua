local M = {}

M.runnable = true

M.build_dir = "build/elisp"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.emacs_binary = "emacs"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[elisp-setup]"
M.log_prefix_compile = "[elisp-compile]"
M.log_prefix_bundle = "[elisp-bundle]"
M.log_prefix_test = "[elisp-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.el",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "elisp",
        output_name = "app",
        setup_description = "Verify emacs and prepare build directory",
        compile_description = "Batch-load Emacs Lisp sources with emacs --batch -l",
        bundle_description = "Verify elisp compile stamp",
        test_description = "Run primary Emacs Lisp file in batch mode",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "elisp",
        output_name = "app",
        setup_description = "Verify emacs and prepare build directory (debug)",
        compile_description = "Batch-load Emacs Lisp sources with emacs --batch -l (debug)",
        bundle_description = "Verify elisp debug compile stamp",
        test_description = "Run primary Emacs Lisp file in batch mode (verbose)",
        test_args = "--debug-init",
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
