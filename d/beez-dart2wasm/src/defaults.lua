local M = {}

M.runnable = true

M.build_dir = "build/dart2wasm"
M.wasm_dir = M.build_dir
M.reports_dir = "report"

M.dart_binary = "dart"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dart2wasm-setup]"
M.log_prefix_compile = "[dart2wasm-compile]"
M.log_prefix_bundle = "[dart2wasm-bundle]"
M.log_prefix_test = "[dart2wasm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pubspec.yaml",
    "**/pubspec.yaml",
    "**/*.dart",
}

M.build_profiles = {
    code = {
        scope = "wasm",
        compile_mode = "wasm",
        output_name = "main.dart",
        compile_args = { "-O4" },
        setup_description = "Install Dart dependencies with dart pub get",
        compile_description = "Compile Dart to WebAssembly (dart compile wasm -O4)",
        bundle_description = "Verify Dart2Wasm build artifacts",
        test_description = "Run Dart tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        compile_mode = "wasm",
        output_name = "main.dart",
        compile_args = { "-O0", "--enable-asserts" },
        setup_description = "Install Dart dependencies with dart pub get (debug)",
        compile_description = "Compile Dart to WebAssembly (debug, -O0)",
        bundle_description = "Verify Dart2Wasm debug artifacts",
        test_description = "Run Dart tests (verbose)",
        test_args = "--reporter=expanded",
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
