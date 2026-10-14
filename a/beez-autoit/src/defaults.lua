local M = {}

M.runnable = true

M.build_dir = "build/autoit"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.wine_binary = "wine"
M.autoit3_binary = "AutoIt3.exe"
M.aut2exe_binary = "Aut2exe.exe"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[autoit-setup]"
M.log_prefix_compile = "[autoit-compile]"
M.log_prefix_bundle = "[autoit-bundle]"
M.log_prefix_test = "[autoit-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.au3",
}

M.build_profiles = {
    code = {
        scope = "autoit",
        output_name = "app.exe",
        setup_description = "Verify Wine and AutoIt3 under Wine",
        compile_description = "Syntax-check AutoIt sources via Wine",
        bundle_description = "Verify AutoIt compile stamp",
        test_description = "Validate AutoIt script compilation",
        compile_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.exe",
        setup_description = "Verify Wine and AutoIt3 under Wine (debug)",
        compile_description = "Syntax-check AutoIt sources via Wine (verbose)",
        bundle_description = "Verify AutoIt debug compile stamp",
        test_description = "Validate AutoIt script compilation (verbose)",
        compile_args = "/ErrorStdOut",
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
