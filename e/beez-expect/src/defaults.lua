local M = {}

M.runnable = true

M.build_dir = "build/expect"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.expect_binary = "expect"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[expect-setup]"
M.log_prefix_compile = "[expect-compile]"
M.log_prefix_bundle = "[expect-bundle]"
M.log_prefix_test = "[expect-test]"
M.log_prefix_run = "[expect-run]"

M.common_inputs = {
    "**/*.exp"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Expect runtime and prepare build directory",
        compile_description = "Validate Expect entry with expect",
        bundle_description = "Verify Expect compile stamp",
        test_description = "Run primary Expect entry",
        test_args = "",
        run_description = "Run Expect application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Expect runtime (debug)",
        compile_description = "Validate Expect entry with expect (debug)",
        bundle_description = "Verify Expect debug compile stamp",
        test_description = "Run primary Expect entry (verbose)",
        test_args = "",
        run_description = "Run Expect application (debug)",
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
