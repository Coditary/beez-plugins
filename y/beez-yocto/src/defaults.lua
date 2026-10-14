local M = {}

M.runnable = false

M.build_dir = "build/yocto"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.bitbake_binary = "bitbake"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[yocto-setup]"
M.log_prefix_compile = "[yocto-compile]"
M.log_prefix_bundle = "[yocto-bundle]"
M.log_prefix_test = "[yocto-test]"


M.common_inputs = {
    "conf/local.conf",
    "**/conf/local.conf",
    "**/*.bb",
    "**/*.bbappend",
}

M.build_profiles = {
    code = {
        scope = "yocto",
        output_name = "parse.ok",
        bb_target = "core-image-minimal",
        setup_description = "Verify BitBake CLI and Yocto build configuration",
        compile_description = "Parse Yocto recipes and validate the build environment",
        bundle_description = "Verify Yocto parse/build artifacts",
        test_description = "Validate Yocto layer and recipe syntax",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "parse.ok",
        bb_target = "core-image-minimal",
        setup_description = "Verify BitBake CLI (debug)",
        compile_description = "Parse Yocto recipes with verbose output (debug)",
        bundle_description = "Verify Yocto debug parse artifacts",
        test_description = "Validate Yocto recipes (verbose)",
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
