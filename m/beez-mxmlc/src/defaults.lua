local M = {}

M.runnable = false

M.build_dir = "build/mxmlc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mxmlc_binary = "mxmlc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mxmlc-setup]"
M.log_prefix_compile = "[mxmlc-compile]"
M.log_prefix_bundle = "[mxmlc-bundle]"
M.log_prefix_test = "[mxmlc-test]"


M.common_inputs = {
    "**/*.mxml",
    "**/*.as",
}

M.build_profiles = {
    code = {
        scope = "mxmlc",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify mxmlc (Adobe Flex SDK) toolchain",
        compile_description = "Compile MXML/ActionScript with mxmlc",
        bundle_description = "Verify mxmlc build artifacts",
        test_description = "Run mxmlc tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "-debug=true",
        setup_description = "Verify mxmlc toolchain (debug)",
        compile_description = "Compile MXML/ActionScript with mxmlc (debug)",
        bundle_description = "Verify mxmlc debug artifacts",
        test_description = "Run mxmlc tests (verbose)",
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
