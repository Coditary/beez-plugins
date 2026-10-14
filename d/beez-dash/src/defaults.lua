local M = {}

M.runnable = true

M.build_dir = "build/dash"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dash_binary = "dash"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[dash-setup]"
M.log_prefix_compile = "[dash-compile]"
M.log_prefix_bundle = "[dash-bundle]"
M.log_prefix_test = "[dash-test]"
M.log_prefix_run = "[dash-run]"

M.common_inputs = {
    "**/*.sh"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Dash runtime and prepare build directory",
        compile_description = "Validate Dash entry with dash",
        bundle_description = "Verify Dash compile stamp",
        test_description = "Run primary Dash entry",
        test_args = "",
        run_description = "Run Dash application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Dash runtime (debug)",
        compile_description = "Validate Dash entry with dash (debug)",
        bundle_description = "Verify Dash debug compile stamp",
        test_description = "Run primary Dash entry (verbose)",
        test_args = "",
        run_description = "Run Dash application (debug)",
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
