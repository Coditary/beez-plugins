local M = {}

M.runnable = true

M.build_dir = "build/iverilog"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.iverilog_binary = "iverilog"
M.vvp_binary = "vvp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[iverilog-setup]"
M.log_prefix_compile = "[iverilog-compile]"
M.log_prefix_bundle = "[iverilog-bundle]"
M.log_prefix_test = "[iverilog-test]"
M.log_prefix_run = "[iverilog-run]"

M.common_inputs = {
    "**/*.v"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Iverilog runtime and prepare build directory",
        compile_description = "Validate Iverilog entry with iverilog",
        bundle_description = "Verify Iverilog compile stamp",
        test_description = "Run primary Iverilog entry",
        test_args = "",
        run_description = "Run Iverilog application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Iverilog runtime (debug)",
        compile_description = "Validate Iverilog entry with iverilog (debug)",
        bundle_description = "Verify Iverilog debug compile stamp",
        test_description = "Run primary Iverilog entry (verbose)",
        test_args = "",
        run_description = "Run Iverilog application (debug)",
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
