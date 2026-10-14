local M = {}

M.runnable = true

M.build_dir = "build/csound"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.csound_binary = "csound"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[csound-setup]"
M.log_prefix_compile = "[csound-compile]"
M.log_prefix_bundle = "[csound-bundle]"
M.log_prefix_test = "[csound-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.csd",
    "**/*.orc",
    "**/*.sco",
}

M.build_profiles = {
    code = {
        scope = "csound",
        output_name = "app.wav",
        setup_description = "Verify Csound synthesis binary",
        compile_description = "Render Csound orchestra/score to WAV",
        bundle_description = "Verify Csound build artifacts",
        test_description = "Validate Csound synthesis",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app-debug.wav",
        setup_description = "Verify Csound synthesis binary (debug)",
        compile_description = "Render Csound orchestra/score to WAV (verbose)",
        bundle_description = "Verify Csound debug artifacts",
        test_description = "Validate Csound synthesis (verbose)",
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
