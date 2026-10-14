local M = {}

M.runnable = true

M.build_dir = "build/micropython"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.micropython_binary = "micropython"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[micropython-setup]"
M.log_prefix_compile = "[micropython-compile]"
M.log_prefix_bundle = "[micropython-bundle]"
M.log_prefix_test = "[micropython-test]"
M.log_prefix_run = "[micropython-run]"

M.common_inputs = {
    "**/*.py"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Micropython runtime and prepare build directory",
        compile_description = "Validate Micropython entry with micropython",
        bundle_description = "Verify Micropython compile stamp",
        test_description = "Run primary Micropython entry",
        test_args = "",
        run_description = "Run Micropython application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Micropython runtime (debug)",
        compile_description = "Validate Micropython entry with micropython (debug)",
        bundle_description = "Verify Micropython debug compile stamp",
        test_description = "Run primary Micropython entry (verbose)",
        test_args = "",
        run_description = "Run Micropython application (debug)",
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
