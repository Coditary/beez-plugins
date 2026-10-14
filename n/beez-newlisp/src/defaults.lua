local M = {}

M.runnable = true

M.build_dir = "build/newlisp"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.newlisp_binary = "newlisp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[newlisp-setup]"
M.log_prefix_compile = "[newlisp-compile]"
M.log_prefix_bundle = "[newlisp-bundle]"
M.log_prefix_test = "[newlisp-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.lsp",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "newlisp",
        output_name = "app",
        setup_description = "Verify newLISP and prepare build directory",
        compile_description = "Compile/validate newLISP targets",
        bundle_description = "Verify newlisp compile stamp",
        test_description = "Run primary newLISP target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "newlisp",
        output_name = "app",
        setup_description = "Verify newLISP and prepare build directory (debug)",
        compile_description = "Compile/validate newLISP targets (debug)",
        bundle_description = "Verify newlisp debug compile stamp",
        test_description = "Run primary newLISP target (debug)",
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
