local M = {}

M.runnable = true

M.build_dir = "build/chuck"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.chuck_binary = "chuck"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[chuck-setup]"
M.log_prefix_compile = "[chuck-compile]"
M.log_prefix_bundle = "[chuck-bundle]"
M.log_prefix_test = "[chuck-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ck",
}

M.build_profiles = {
    code = {
        scope = "chuck",
        output_name = "app.wav",
        render_duration = "10.0::second",
        setup_description = "Verify ChucK audio runtime binary",
        compile_description = "Render ChucK script to WAV",
        bundle_description = "Verify ChucK build artifacts",
        test_description = "Validate ChucK script execution",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app-debug.wav",
        render_duration = "5.0::second",
        setup_description = "Verify ChucK audio runtime binary (debug)",
        compile_description = "Render ChucK script to WAV (verbose)",
        bundle_description = "Verify ChucK debug artifacts",
        test_description = "Validate ChucK script execution (verbose)",
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
