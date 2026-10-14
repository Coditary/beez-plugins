local M = {}

M.runnable = true

M.build_dir = "build/jq"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.jq_binary = "jq"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jq-setup]"
M.log_prefix_compile = "[jq-compile]"
M.log_prefix_bundle = "[jq-bundle]"
M.log_prefix_test = "[jq-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.jq",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "jq",
        output_name = "app",
        setup_description = "Verify jq and prepare build directory",
        compile_description = "Validate jq filters with jq -n -f",
        bundle_description = "Verify jq compile stamp",
        test_description = "Run primary jq filter",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jq",
        output_name = "app",
        setup_description = "Verify jq and prepare build directory (debug)",
        compile_description = "Validate jq filters with jq -n -f (debug)",
        bundle_description = "Verify jq debug compile stamp",
        test_description = "Run primary jq filter (debug)",
        test_args = "",
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
