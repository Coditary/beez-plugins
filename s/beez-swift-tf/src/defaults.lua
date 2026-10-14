local M = {}

M.runnable = true

M.build_dir = "build/swift-tf"
M.release_bin_dir = M.build_dir .. "/release"
M.debug_bin_dir = M.build_dir .. "/debug"
M.reports_dir = "report"

M.swift_binary = "swift"
M.swiftc_binary = "swiftc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[swift-tf-setup]"
M.log_prefix_compile = "[swift-tf-compile]"
M.log_prefix_bundle = "[swift-tf-bundle]"
M.log_prefix_test = "[swift-tf-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Package.swift",
    "Package.resolved",
    "**/*.swift",
}

M.build_profiles = {
    code = {
        scope = "swift-tf",
        build_mode = "release",
        build_path = M.build_dir,
        bin_dir = M.release_bin_dir,
        configuration = "release",
        extra_args = {},
        setup_description = "Resolve Swift for TensorFlow package dependencies",
        compile_description = "Build with S4TF toolchain (release)",
        bundle_description = "Verify Swift for TensorFlow release binaries",
        test_description = "Run Swift for TensorFlow tests",
        test_args = "",
        test_filter = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        build_path = M.build_dir,
        bin_dir = M.debug_bin_dir,
        configuration = "debug",
        extra_args = {},
        setup_description = "Resolve Swift for TensorFlow package dependencies (debug)",
        compile_description = "Build with S4TF toolchain (debug)",
        bundle_description = "Verify Swift for TensorFlow debug binaries",
        test_description = "Run Swift for TensorFlow tests (verbose)",
        test_args = "--verbose",
        test_filter = "",
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
