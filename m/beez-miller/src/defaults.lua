local M = {}

M.runnable = true

M.build_dir = "build/miller"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.miller_binary = "mlr"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[miller-setup]"
M.log_prefix_compile = "[miller-compile]"
M.log_prefix_bundle = "[miller-bundle]"
M.log_prefix_test = "[miller-test]"
M.log_prefix_run = "[miller-run]"

M.common_inputs = {
    "**/*.mlr"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Miller runtime and prepare build directory",
        compile_description = "Validate Miller entry with mlr",
        bundle_description = "Verify Miller compile stamp",
        test_description = "Run primary Miller entry",
        test_args = "",
        run_description = "Run Miller application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Miller runtime (debug)",
        compile_description = "Validate Miller entry with mlr (debug)",
        bundle_description = "Verify Miller debug compile stamp",
        test_description = "Run primary Miller entry (verbose)",
        test_args = "",
        run_description = "Run Miller application (debug)",
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
