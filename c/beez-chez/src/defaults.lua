local M = {}

M.runnable = true

M.build_dir = "build/chez"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.chez_binary = "scheme"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[chez-setup]"
M.log_prefix_compile = "[chez-compile]"
M.log_prefix_bundle = "[chez-bundle]"
M.log_prefix_test = "[chez-test]"
M.log_prefix_run = "[chez-run]"

M.common_inputs = {
    "**/*.ss",
    "**/*.scm",
    "**/*.sls"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "--script",
        setup_description = "Verify Chez runtime and prepare build directory",
        compile_description = "Validate Chez entry with scheme",
        bundle_description = "Verify Chez compile stamp",
        test_description = "Run primary Chez entry",
        test_args = "",
        run_description = "Run Chez application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "--script",
        setup_description = "Verify Chez runtime (debug)",
        compile_description = "Validate Chez entry with scheme (debug)",
        bundle_description = "Verify Chez debug compile stamp",
        test_description = "Run primary Chez entry (verbose)",
        test_args = "",
        run_description = "Run Chez application (debug)",
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
