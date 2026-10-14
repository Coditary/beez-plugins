local M = {}

M.runnable = true

M.build_dir = "build/grain"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.grain_binary = "grain"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[grain-setup]"
M.log_prefix_compile = "[grain-compile]"
M.log_prefix_bundle = "[grain-bundle]"
M.log_prefix_test = "[grain-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "grain.json",
    "**/grain.json",
    "**/*.gr",
}

M.build_profiles = {
    code = {
        scope = "grain",
        output_name = "app.wasm",
        compile_flags = "--release",
        setup_description = "Verify Grain compiler (Wasm toolchain)",
        compile_description = "Compile Grain to WebAssembly",
        bundle_description = "Verify Grain Wasm artifacts",
        test_description = "Run Grain tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.wasm",
        compile_flags = "--debug",
        setup_description = "Verify Grain compiler (debug)",
        compile_description = "Compile Grain to WebAssembly (debug)",
        bundle_description = "Verify Grain debug Wasm artifacts",
        test_description = "Run Grain tests (verbose)",
        test_args = "-v",
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
