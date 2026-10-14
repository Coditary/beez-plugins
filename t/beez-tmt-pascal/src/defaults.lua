local M = {}

M.runnable = true

M.build_dir = "build/tmt-pascal"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.tmt_pascal_binary = "tmtpc"
M.tmt_pascal_binary_64 = "tmt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tmt-pascal-setup]"
M.log_prefix_compile = "[tmt-pascal-compile]"
M.log_prefix_bundle = "[tmt-pascal-bundle]"
M.log_prefix_test = "[tmt-pascal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.tmt",
    "*.dpr",
    "**/*.tmt",
    "**/*.dpr",
    "**/*.pas",
}

M.build_profiles = {
    code = {
        scope = "tmt-pascal",
        build_mode = "release",
        output_name = "app",
        optimize = "-$OPT+",
        setup_description = "Prepare TMT Pascal build environment",
        compile_description = "Build with TMT Pascal (release, -$OPT+)",
        bundle_description = "Verify TMT Pascal build artifacts",
        test_description = "Run Pascal tests with TMT Pascal",
        test_args = "",
        run_description = "Run application (code)",
    },
    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        optimize = "-$OPT- -$DEBUGINFO+",
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
