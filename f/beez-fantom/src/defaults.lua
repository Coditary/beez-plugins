local M = {}

M.runnable = true

M.build_dir = "build/fantom"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.fan_binary = "fan"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fantom-setup]"
M.log_prefix_compile = "[fantom-compile]"
M.log_prefix_bundle = "[fantom-bundle]"
M.log_prefix_test = "[fantom-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.fan",
    "**/build.fan",
    "**/*.fan",
}

M.build_profiles = {
    code = {
        scope = "fantom",
        output_name = "app",
        setup_description = "Verify fan binary and prepare build directory",
        compile_description = "Build Fantom project with fan build",
        bundle_description = "Verify Fantom build artifacts",
        test_description = "Run Fantom tests with fan test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "fantom",
        output_name = "app",
        setup_description = "Verify fan binary and prepare build directory (debug)",
        compile_description = "Build Fantom project with fan build (debug)",
        bundle_description = "Verify Fantom build artifacts (debug)",
        test_description = "Run Fantom tests with fan test (verbose)",
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
