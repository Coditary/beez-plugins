local M = {}

M.runnable = true

M.build_dir = "build/dart"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.dart_binary = "dart"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dart-setup]"
M.log_prefix_compile = "[dart-compile]"
M.log_prefix_bundle = "[dart-bundle]"
M.log_prefix_test = "[dart-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pubspec.yaml",
    "**/pubspec.yaml",
    "**/*.dart",
}

M.build_profiles = {
    code = {
        scope = "app",
        compile_mode = "aot",
        output_name = "app",
        compile_args = {},
        setup_description = "Install Dart dependencies with dart pub get",
        compile_description = "Compile Dart to native executable (AOT)",
        bundle_description = "Verify Dart build artifacts",
        test_description = "Run Dart tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        compile_mode = "aot",
        output_name = "app",
        compile_args = { "--enable-asserts" },
        setup_description = "Install Dart dependencies with dart pub get (debug)",
        compile_description = "Compile Dart to native executable (debug AOT)",
        bundle_description = "Verify Dart debug artifacts",
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
