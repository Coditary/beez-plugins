local M = {}

M.runnable = false

M.build_dir = "build/buck2"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.buck2_binary = "buck2"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[buck2-setup]"
M.log_prefix_compile = "[buck2-compile]"
M.log_prefix_bundle = "[buck2-bundle]"
M.log_prefix_test = "[buck2-test]"


M.common_inputs = {
    "BUCK",
    ".buckconfig",
    "**/BUCK",
}

M.build_profiles = {
    code = {
        scope = "buck2",
        output_name = "build.ok",
        build_target = "//...",
        test_target = "//...",
        setup_description = "Verify Buck2 CLI and project configuration",
        compile_description = "Build Buck2 targets across the project",
        bundle_description = "Verify Buck2 build artifacts",
        test_description = "Run Buck2 test targets",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        build_target = "//...",
        test_target = "//...",
        setup_description = "Verify Buck2 CLI (debug)",
        compile_description = "Build Buck2 targets with verbose output (debug)",
        bundle_description = "Verify Buck2 debug build artifacts",
        test_description = "Run Buck2 tests (verbose)",
        test_args = "--verbose",
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
