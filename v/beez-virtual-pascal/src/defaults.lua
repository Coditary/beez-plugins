local M = {}

M.runnable = true

M.build_dir = "build/virtual-pascal"
M.bin_dir = M.build_dir .. "/bin"
M.obj_dir = M.build_dir .. "/obj"
M.reports_dir = "report"

M.vpc_binary = "vpc"
M.vpo_file = "vp.vpo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[virtual-pascal-setup]"
M.log_prefix_compile = "[virtual-pascal-compile]"
M.log_prefix_bundle = "[virtual-pascal-bundle]"
M.log_prefix_test = "[virtual-pascal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.vpj",
    "**/*.vpj",
    "*.pas",
    "**/*.pas",
}

M.build_profiles = {
    code = {
        scope = "virtual-pascal",
        build_mode = "release",
        output_name = "app",
        vpc_args = "-B",
        setup_description = "Prepare Virtual Pascal build environment",
        compile_description = "Build with Virtual Pascal (release, -B)",
        bundle_description = "Verify Virtual Pascal build artifacts",
        test_description = "Run Pascal tests with Virtual Pascal",
        test_args = "",
        run_description = "Run application (code)",
    },
    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        optimize = "-$O- -$D+",
        setup_description = "Prepare build environment (debug)",
        compile_description = "Build with debug symbols",
        bundle_description = "Verify debug build artifacts",
        test_description = "Run tests (verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
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
