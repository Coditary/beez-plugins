local M = {}

M.runnable = true

M.build_dir = "build/mercury"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mmc_binary = "mmc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mercury-setup]"
M.log_prefix_compile = "[mercury-compile]"
M.log_prefix_bundle = "[mercury-bundle]"
M.log_prefix_test = "[mercury-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Mercury.options",
    "**/Mercury.options",
    "**/*.m",
}

M.build_profiles = {
    code = {
        scope = "mercury",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify Mercury toolchain and prepare build directories",
        compile_description = "Compile Mercury sources (mercury)",
        bundle_description = "Verify Mercury build artifacts",
        test_description = "Run compiled Mercury binary or test suite",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "mercury",
        output_name = "app",
        optimize = "-g",
        setup_description = "Verify Mercury toolchain (debug profile)",
        compile_description = "Compile Mercury sources with debug info",
        bundle_description = "Verify Mercury debug build artifacts",
        test_description = "Run Mercury tests (debug profile)",
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
