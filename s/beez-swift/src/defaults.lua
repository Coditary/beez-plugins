local M = {}

M.runnable = true

M.build_dir = "build/swift"
M.release_bin_dir = M.build_dir .. "/release"
M.debug_bin_dir = M.build_dir .. "/debug"
M.reports_dir = "report"

M.swift_binary = "swift"
M.swiftc_binary = "swiftc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[swift-setup]"
M.log_prefix_compile = "[swift-compile]"
M.log_prefix_bundle = "[swift-bundle]"
M.log_prefix_test = "[swift-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Package.swift",
    "Package.resolved",
    "**/*.swift",
}

M.build_profiles = {
    code = {
        scope = "app",
        build_mode = "release",
        build_path = M.build_dir,
        bin_dir = M.release_bin_dir,
        configuration = "release",
        extra_args = {},
        setup_description = "Resolve Swift package dependencies",
        compile_description = "Build with swiftc (release, optimized)",
        bundle_description = "Verify Swift release binaries",
        test_description = "Run Swift tests",
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
        setup_description = "Resolve Swift package dependencies (debug)",
        compile_description = "Build with swiftc (debug, no optimizations)",
        bundle_description = "Verify Swift debug binaries",
        test_description = "Run Swift tests (verbose)",
        test_args = "--verbose",
        test_filter = "",
    },

    coverage = {
        scope = "coverage",
        build_mode = "coverage",
        build_path = M.build_dir,
        bin_dir = M.debug_bin_dir,
        configuration = "debug",
        extra_args = { "--enable-code-coverage" },
        setup_description = "Resolve Swift package dependencies (coverage)",
        compile_description = "Build with swiftc (coverage instrumentation)",
        bundle_description = "Verify Swift coverage binaries",
        test_description = "Run Swift tests with code coverage",
        test_args = "--enable-code-coverage",
        test_filter = "",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
    ["configure:coverage"] = "coverage",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
    ["compile:coverage"] = "coverage",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
    ["bundle:coverage"] = "coverage",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
    ["test:coverage"] = "coverage",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:coverage"] = "coverage",
    ["run:debug"] = "debug",
}

return M
