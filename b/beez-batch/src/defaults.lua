local M = {}

M.runnable = true

M.build_dir = "build/batch"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.wine_binary = "wine"
M.cmd_binary = "cmd.exe"
M.dosbox_binary = "dosbox"
M.batch_backend = "wine"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[batch-setup]"
M.log_prefix_compile = "[batch-compile]"
M.log_prefix_bundle = "[batch-bundle]"
M.log_prefix_test = "[batch-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bat",
    "**/*.cmd",
}

M.build_profiles = {
    code = {
        scope = "batch",
        output_name = "app.bat",
        setup_description = "Verify Wine cmd.exe or DOSBox for batch scripts",
        compile_description = "Validate Windows batch scripts via Wine or DOSBox",
        bundle_description = "Verify batch compile stamp",
        test_description = "Validate batch script execution",
        compile_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.bat",
        setup_description = "Verify Wine cmd.exe or DOSBox for batch scripts (debug)",
        compile_description = "Validate Windows batch scripts via Wine or DOSBox (verbose)",
        bundle_description = "Verify batch debug compile stamp",
        test_description = "Validate batch script execution (verbose)",
        compile_args = "/v:on",
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
