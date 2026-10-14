local M = {}

M.runnable = true

M.build_dir = "build/jsonnet"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.jsonnet_binary = "jsonnet"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[jsonnet-setup]"
M.log_prefix_compile = "[jsonnet-compile]"
M.log_prefix_bundle = "[jsonnet-bundle]"
M.log_prefix_test = "[jsonnet-test]"
M.log_prefix_run = "[jsonnet-run]"

M.common_inputs = {
    "**/*.jsonnet",
    "**/*.libsonnet"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Jsonnet runtime and prepare build directory",
        compile_description = "Validate Jsonnet entry with jsonnet",
        bundle_description = "Verify Jsonnet compile stamp",
        test_description = "Run primary Jsonnet entry",
        test_args = "",
        run_description = "Run Jsonnet application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Jsonnet runtime (debug)",
        compile_description = "Validate Jsonnet entry with jsonnet (debug)",
        bundle_description = "Verify Jsonnet debug compile stamp",
        test_description = "Run primary Jsonnet entry (verbose)",
        test_args = "",
        run_description = "Run Jsonnet application (debug)",
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
