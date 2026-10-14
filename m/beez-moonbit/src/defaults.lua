local M = {}

M.runnable = true

M.build_dir = "build/moonbit"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.moon_binary = "moon"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[moonbit-setup]"
M.log_prefix_compile = "[moonbit-compile]"
M.log_prefix_bundle = "[moonbit-bundle]"
M.log_prefix_test = "[moonbit-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "moon.pkg.json",
    "**/moon.pkg.json",
    "**/*.mbt",
}

M.build_profiles = {
    code = {
        scope = "moonbit",
        output_name = "app",
        setup_description = "Verify MoonBit compiler binary",
        compile_description = "Compile MoonBit package via moon build",
        bundle_description = "Verify MoonBit build artifacts",
        test_description = "Run MoonBit tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify MoonBit compiler binary (debug)",
        compile_description = "Compile MoonBit package (debug)",
        bundle_description = "Verify MoonBit debug artifacts",
        test_description = "Run MoonBit tests (verbose)",
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
