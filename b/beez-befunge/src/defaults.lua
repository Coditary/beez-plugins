local M = {}

M.runnable = true

M.build_dir = "build/befunge"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.befunge_binary = "befunge"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[befunge-setup]"
M.log_prefix_compile = "[befunge-compile]"
M.log_prefix_bundle = "[befunge-bundle]"
M.log_prefix_test = "[befunge-test]"
M.log_prefix_run = "[befunge-run]"

M.common_inputs = {
    "**/*.bf",
    "**/*.bef",
    "**/*.befunge"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Befunge runtime and prepare build directory",
        compile_description = "Validate Befunge entry with befunge",
        bundle_description = "Verify Befunge compile stamp",
        test_description = "Run primary Befunge entry",
        test_args = "",
        run_description = "Run Befunge application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Befunge runtime (debug)",
        compile_description = "Validate Befunge entry with befunge (debug)",
        bundle_description = "Verify Befunge debug compile stamp",
        test_description = "Run primary Befunge entry (verbose)",
        test_args = "",
        run_description = "Run Befunge application (debug)",
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
