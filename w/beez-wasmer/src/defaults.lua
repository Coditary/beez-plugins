local M = {}

M.runnable = true

M.build_dir = "build/wasmer"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.wasmer_binary = "wasmer"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[wasmer-setup]"
M.log_prefix_compile = "[wasmer-compile]"
M.log_prefix_bundle = "[wasmer-bundle]"
M.log_prefix_test = "[wasmer-test]"
M.log_prefix_run = "[wasmer-run]"

M.common_inputs = {
    "**/*.wasm"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "wasm",
        output_name = "app",
        run_args = "",
        run_prefix = "run",
        setup_description = "Verify Wasmer runtime and prepare build directory",
        compile_description = "Validate Wasmer entry with wasmer",
        bundle_description = "Verify Wasmer compile stamp",
        test_description = "Run primary Wasmer entry",
        test_args = "",
        run_description = "Run Wasmer application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "run",
        setup_description = "Verify Wasmer runtime (debug)",
        compile_description = "Validate Wasmer entry with wasmer (debug)",
        bundle_description = "Verify Wasmer debug compile stamp",
        test_description = "Run primary Wasmer entry (verbose)",
        test_args = "",
        run_description = "Run Wasmer application (debug)",
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
