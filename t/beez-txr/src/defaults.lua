local M = {}

M.runnable = true

M.build_dir = "build/txr"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.txr_binary = "txr"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[txr-setup]"
M.log_prefix_compile = "[txr-compile]"
M.log_prefix_bundle = "[txr-bundle]"
M.log_prefix_test = "[txr-test]"
M.log_prefix_run = "[txr-run]"

M.common_inputs = {
    "**/*.txr"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Txr runtime and prepare build directory",
        compile_description = "Validate Txr entry with txr",
        bundle_description = "Verify Txr compile stamp",
        test_description = "Run primary Txr entry",
        test_args = "",
        run_description = "Run Txr application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Txr runtime (debug)",
        compile_description = "Validate Txr entry with txr (debug)",
        bundle_description = "Verify Txr debug compile stamp",
        test_description = "Run primary Txr entry (verbose)",
        test_args = "",
        run_description = "Run Txr application (debug)",
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
