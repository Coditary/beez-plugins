local M = {}

M.runnable = true

M.build_dir = "build/sphinx"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.sphinx_binary = "sphinx"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sphinx-setup]"
M.log_prefix_compile = "[sphinx-compile]"
M.log_prefix_bundle = "[sphinx-bundle]"
M.log_prefix_test = "[sphinx-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.c--",
}

M.compile_exclude = [[/(\.git|build|\.venv|local|target|_build)/]]

M.build_profiles = {
    code = {
        scope = "sphinx",
        output_name = "app",
        setup_description = "Verify sphinx and prepare build directory",
        compile_description = "Compile/type-check sphinx sources",
        bundle_description = "Verify sphinx compile stamp",
        test_description = "Run sphinx tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "sphinx",
        output_name = "app",
        setup_description = "Verify sphinx and prepare build directory (debug)",
        compile_description = "Compile/type-check sphinx sources (debug)",
        bundle_description = "Verify sphinx debug compile stamp",
        test_description = "Run sphinx tests (verbose)",
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
