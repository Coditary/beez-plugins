local M = {}

M.runnable = false

M.build_dir = "build/asc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.asc_binary = "asc"
M.mxmlc_binary = "mxmlc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[asc-setup]"
M.log_prefix_compile = "[asc-compile]"
M.log_prefix_bundle = "[asc-bundle]"
M.log_prefix_test = "[asc-test]"


M.common_inputs = {
    "**/*.as",
}

M.build_profiles = {
    code = {
        scope = "asc",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify asc/mxmlc ActionScript compiler",
        compile_description = "Compile ActionScript with asc",
        bundle_description = "Verify asc build artifacts",
        test_description = "Run asc tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "-debug",
        setup_description = "Verify asc/mxmlc ActionScript compiler (debug)",
        compile_description = "Compile ActionScript with asc (debug)",
        bundle_description = "Verify asc debug artifacts",
        test_description = "Run asc tests (verbose)",
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
