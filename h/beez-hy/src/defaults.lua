local M = {}

M.runnable = true

M.build_dir = "build/hy"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.hy_binary = "hy"
M.hy2py_binary = "hy2py"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[hy-setup]"
M.log_prefix_compile = "[hy-compile]"
M.log_prefix_bundle = "[hy-bundle]"
M.log_prefix_test = "[hy-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.hy",
}

M.compile_exclude = [[/(\.git|build|\.venv|local|__pycache__)/]]

M.build_profiles = {
    code = {
        scope = "hy",
        output_name = "app",
        setup_description = "Verify hy/hy2py and prepare build directory",
        compile_description = "Transpile Hy sources with hy2py",
        bundle_description = "Verify hy compile stamp",
        test_description = "Run primary Hy script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "hy",
        output_name = "app",
        setup_description = "Verify hy/hy2py and prepare build directory (debug)",
        compile_description = "Transpile Hy sources with hy2py (debug)",
        bundle_description = "Verify hy debug compile stamp",
        test_description = "Run primary Hy script (verbose)",
        test_args = "--verbose",
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
