local M = {}

M.runnable = false

M.build_dir = "build/mock"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mock_binary = "mock"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mock-setup]"
M.log_prefix_compile = "[mock-compile]"
M.log_prefix_bundle = "[mock-bundle]"
M.log_prefix_test = "[mock-test]"


M.common_inputs = {
    "**/*.spec",
    "mock.cfg",
    "**/mock.cfg",
    "site-defaults.cfg",
    "**/site-defaults.cfg",
}

M.build_profiles = {
    code = {
        scope = "mock",
        output_name = "build.ok",
        result_dir = "result",
        mock_config = "fedora-rawhide-x86_64",
        setup_description = "Verify mock CLI and chroot configuration",
        compile_description = "Build RPM packages in Fedora Mock chroot",
        bundle_description = "Verify Mock build artifacts",
        test_description = "Validate Mock configuration and spec files",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        result_dir = "result-debug",
        mock_config = "fedora-rawhide-x86_64",
        setup_description = "Verify mock CLI (debug)",
        compile_description = "Build RPM packages in Mock chroot with verbose output (debug)",
        bundle_description = "Verify Mock debug build artifacts",
        test_description = "Validate Mock configuration (verbose)",
        test_args = "-v",
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


return M
