local M = {}

M.runnable = false

M.build_dir = "build/buildroot"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.make_binary = "make"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[buildroot-setup]"
M.log_prefix_compile = "[buildroot-compile]"
M.log_prefix_bundle = "[buildroot-bundle]"
M.log_prefix_test = "[buildroot-test]"


M.common_inputs = {
    "Config.in",
    "**/Config.in",
    "**/*defconfig",
    "Makefile",
}

M.build_profiles = {
    code = {
        scope = "buildroot",
        output_name = "build.ok",
        image_output = "images",
        setup_description = "Verify Buildroot Makefile and load defconfig",
        compile_description = "Build embedded Linux image with Buildroot make",
        bundle_description = "Verify Buildroot image artifacts",
        test_description = "Validate Buildroot configuration and defconfig",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        image_output = "images-debug",
        setup_description = "Verify Buildroot Makefile (debug)",
        compile_description = "Build Buildroot with verbose make output (debug)",
        bundle_description = "Verify Buildroot debug build artifacts",
        test_description = "Validate Buildroot configuration (verbose)",
        test_args = "V=1",
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
