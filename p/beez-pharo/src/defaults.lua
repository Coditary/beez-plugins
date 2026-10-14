local M = {}

M.runnable = true

M.build_dir = "build/pharo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.pharo_binary = "pharo"
M.squeak_binary = "squeakvm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pharo-setup]"
M.log_prefix_compile = "[pharo-compile]"
M.log_prefix_bundle = "[pharo-bundle]"
M.log_prefix_test = "[pharo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Pharo.image",
    "**/Pharo.image",
    "*.image",
    "**/*.image",
    "*.st",
    "**/*.st",
}

M.build_profiles = {
    code = {
        scope = "pharo",
        build_mode = "release",
        output_name = "app",
        setup_description = "Verify Pharo/Squeak VM binary is available",
        compile_description = "Compile and validate Smalltalk sources (headless Pharo)",
        bundle_description = "Verify Pharo build artifacts",
        test_description = "Run Pharo test runner when present",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "pharo",
        build_mode = "debug",
        output_name = "app",
        setup_description = "Verify Pharo/Squeak VM binary is available (debug)",
        compile_description = "Compile and validate Smalltalk sources (headless Pharo, debug)",
        bundle_description = "Verify Pharo debug build artifacts",
        test_description = "Run Pharo test runner when present (verbose)",
        test_args = "--verbose",
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
