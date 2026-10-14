local M = {}

M.runnable = true

M.build_dir = "build/wren"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.wren_binary = "wren_cli"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[wren-setup]"
M.log_prefix_compile = "[wren-compile]"
M.log_prefix_bundle = "[wren-bundle]"
M.log_prefix_test = "[wren-test]"
M.log_prefix_run = "[wren-run]"

M.common_inputs = {
    "**/*.wren"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Wren runtime and prepare build directory",
        compile_description = "Validate Wren entry with wren_cli",
        bundle_description = "Verify Wren compile stamp",
        test_description = "Run primary Wren entry",
        test_args = "",
        run_description = "Run Wren application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Wren runtime (debug)",
        compile_description = "Validate Wren entry with wren_cli (debug)",
        bundle_description = "Verify Wren debug compile stamp",
        test_description = "Run primary Wren entry (verbose)",
        test_args = "",
        run_description = "Run Wren application (debug)",
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
