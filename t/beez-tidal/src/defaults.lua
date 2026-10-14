local M = {}

M.runnable = true

M.build_dir = "build/tidal"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.tidal_binary = "tidal"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tidal-setup]"
M.log_prefix_compile = "[tidal-compile]"
M.log_prefix_bundle = "[tidal-bundle]"
M.log_prefix_test = "[tidal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.tidal",
}

M.build_profiles = {
    code = {
        scope = "tidal",
        output_name = "app.wav",
        render_duration = "10",
        setup_description = "Verify TidalCycles runtime binary",
        compile_description = "Render TidalCycles pattern to WAV",
        bundle_description = "Verify TidalCycles build artifacts",
        test_description = "Validate TidalCycles pattern execution",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app-debug.wav",
        render_duration = "5",
        setup_description = "Verify TidalCycles runtime binary (debug)",
        compile_description = "Render TidalCycles pattern to WAV (verbose)",
        bundle_description = "Verify TidalCycles debug artifacts",
        test_description = "Validate TidalCycles pattern execution (verbose)",
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
