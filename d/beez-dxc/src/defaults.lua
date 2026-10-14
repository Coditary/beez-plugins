local M = {}

M.runnable = false

M.build_dir = "build/dxc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dxc_binary = "dxc"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dxc-setup]"
M.log_prefix_compile = "[dxc-compile]"
M.log_prefix_bundle = "[dxc-bundle]"
M.log_prefix_test = "[dxc-test]"


M.common_inputs = {
    "**/*.hlsl",
}

M.build_profiles = {
    code = {
        scope = "dxc",
        output_name = "app",
        setup_description = "Verify dxc binary and prepare build directory",
        compile_description = "Compile HLSL shaders to DXIL with dxc",
        bundle_description = "Verify DXIL shader artifacts",
        test_description = "Verify DXIL outputs exist",
        test_args = "",
    },

    debug = {
        scope = "dxc",
        output_name = "app",
        setup_description = "Verify dxc binary and prepare build directory (debug)",
        compile_description = "Compile HLSL shaders to DXIL with dxc (debug)",
        bundle_description = "Verify DXIL shader artifacts (debug)",
        test_description = "Verify DXIL outputs exist (verbose)",
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
