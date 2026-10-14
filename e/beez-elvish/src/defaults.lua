local M = {}

M.runnable = true

M.build_dir = "build/elvish"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.elvish_binary = "elvish"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[elvish-setup]"
M.log_prefix_compile = "[elvish-compile]"
M.log_prefix_bundle = "[elvish-bundle]"
M.log_prefix_test = "[elvish-test]"
M.log_prefix_run = "[elvish-run]"

M.common_inputs = {
    "**/*.elv"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Elvish runtime and prepare build directory",
        compile_description = "Validate Elvish entry with elvish",
        bundle_description = "Verify Elvish compile stamp",
        test_description = "Run primary Elvish entry",
        test_args = "",
        run_description = "Run Elvish application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Elvish runtime (debug)",
        compile_description = "Validate Elvish entry with elvish (debug)",
        bundle_description = "Verify Elvish debug compile stamp",
        test_description = "Run primary Elvish entry (verbose)",
        test_args = "",
        run_description = "Run Elvish application (debug)",
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
