local M = {}

M.runnable = true

M.build_dir = "build/sonic-pi"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.sonic_pi_binary = "sonic-pi"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sonic-pi-setup]"
M.log_prefix_compile = "[sonic-pi-compile]"
M.log_prefix_bundle = "[sonic-pi-bundle]"
M.log_prefix_test = "[sonic-pi-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.rb",
}

M.build_profiles = {
    code = {
        scope = "sonic-pi",
        output_name = "app.wav",
        render_duration = "10.0",
        setup_description = "Verify Sonic Pi live-coding runtime binary",
        compile_description = "Render Sonic Pi buffer to WAV",
        bundle_description = "Verify Sonic Pi build artifacts",
        test_description = "Validate Sonic Pi buffer execution",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app-debug.wav",
        render_duration = "5.0",
        setup_description = "Verify Sonic Pi runtime binary (debug)",
        compile_description = "Render Sonic Pi buffer to WAV (verbose)",
        bundle_description = "Verify Sonic Pi debug artifacts",
        test_description = "Validate Sonic Pi buffer execution (verbose)",
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
