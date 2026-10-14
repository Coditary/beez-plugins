local M = {}

M.runnable = true

M.build_dir = "build/jbang"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.jbang_binary = "jbang"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[jbang-setup]"
M.log_prefix_compile = "[jbang-compile]"
M.log_prefix_bundle = "[jbang-bundle]"
M.log_prefix_test = "[jbang-test]"
M.log_prefix_run = "[jbang-run]"

M.common_inputs = {
    "**/*.java",
    "**/*.jsh"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Jbang runtime and prepare build directory",
        compile_description = "Validate Jbang entry with jbang",
        bundle_description = "Verify Jbang compile stamp",
        test_description = "Run primary Jbang entry",
        test_args = "",
        run_description = "Run Jbang application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Jbang runtime (debug)",
        compile_description = "Validate Jbang entry with jbang (debug)",
        bundle_description = "Verify Jbang debug compile stamp",
        test_description = "Run primary Jbang entry (verbose)",
        test_args = "",
        run_description = "Run Jbang application (debug)",
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
