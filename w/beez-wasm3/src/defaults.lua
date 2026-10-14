local M = {}

M.runnable = true

M.build_dir = "build/wasm3"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.wasm3_binary = "wasm3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[wasm3-setup]"
M.log_prefix_compile = "[wasm3-compile]"
M.log_prefix_bundle = "[wasm3-bundle]"
M.log_prefix_test = "[wasm3-test]"
M.log_prefix_run = "[wasm3-run]"

M.common_inputs = {
    "**/*.wasm"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "wasm",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Wasm3 runtime and prepare build directory",
        compile_description = "Validate Wasm3 entry with wasm3",
        bundle_description = "Verify Wasm3 compile stamp",
        test_description = "Run primary Wasm3 entry",
        test_args = "",
        run_description = "Run Wasm3 application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Wasm3 runtime (debug)",
        compile_description = "Validate Wasm3 entry with wasm3 (debug)",
        bundle_description = "Verify Wasm3 debug compile stamp",
        test_description = "Run primary Wasm3 entry (verbose)",
        test_args = "",
        run_description = "Run Wasm3 application (debug)",
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
