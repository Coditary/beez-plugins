local M = {}

M.runnable = true

M.build_dir = "build/ddc"
M.js_dir = M.build_dir
M.reports_dir = "report"

M.dart_binary = "dart"
M.dartdevc_binary = "dartdevc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ddc-setup]"
M.log_prefix_compile = "[ddc-compile]"
M.log_prefix_bundle = "[ddc-bundle]"
M.log_prefix_test = "[ddc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pubspec.yaml",
    "**/pubspec.yaml",
    "**/*.dart",
}

M.build_profiles = {
    code = {
        scope = "ddc",
        compile_mode = "js",
        output_name = "app",
        compile_args = { "--no-sound-null-safety" },
        setup_description = "Install Dart dependencies with dart pub get",
        compile_description = "Compile Dart to JavaScript with DDC (dart compile js)",
        bundle_description = "Verify DDC JavaScript build artifacts",
        test_description = "Run Dart tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        compile_mode = "js",
        output_name = "app",
        compile_args = { "--no-sound-null-safety", "-O0" },
        setup_description = "Install Dart dependencies with dart pub get (debug)",
        compile_description = "Compile Dart to JavaScript with DDC (debug, -O0)",
        bundle_description = "Verify DDC debug JavaScript artifacts",
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
