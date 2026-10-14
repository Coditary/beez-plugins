local M = {}

M.runnable = true

M.build_dir = "build/assemblyscript"
M.wasm_dir = M.build_dir .. "/wasm"
M.reports_dir = "report"

M.asc_binary = "npx asc"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[assemblyscript-setup]"
M.log_prefix_compile = "[assemblyscript-compile]"
M.log_prefix_bundle = "[assemblyscript-bundle]"
M.log_prefix_test = "[assemblyscript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "asconfig.json",
    "**/asconfig.json",
    "package.json",
    "**/package.json",
    "**/*.ts",
}

M.build_profiles = {
    code = {
        scope = "wasm",
        build_mode = "release",
        asc_target = "release",
        output_name = "index",
        setup_description = "Install AssemblyScript dependencies with npm",
        compile_description = "Compile AssemblyScript to WebAssembly with asc (release)",
        bundle_description = "Verify AssemblyScript Wasm artifacts",
        test_description = "Run AssemblyScript project tests",
        asc_args = "--optimize",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "wasm",
        build_mode = "debug",
        asc_target = "debug",
        output_name = "index",
        setup_description = "Install AssemblyScript dependencies with npm (debug)",
        compile_description = "Compile AssemblyScript to WebAssembly with asc (debug)",
        bundle_description = "Verify AssemblyScript debug Wasm artifacts",
        test_description = "Run AssemblyScript project tests (verbose)",
        asc_args = "--debug",
        test_args = "--verbose",
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
