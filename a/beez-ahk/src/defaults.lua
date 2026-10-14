local M = {}

M.runnable = true

M.build_dir = "build/ahk"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.wine_binary = "wine"
M.ahk_binary = "AutoHotkeyU64.exe"
M.ahk2exe_binary = "Ahk2Exe.exe"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ahk-setup]"
M.log_prefix_compile = "[ahk-compile]"
M.log_prefix_bundle = "[ahk-bundle]"
M.log_prefix_test = "[ahk-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ahk",
}

M.build_profiles = {
    code = {
        scope = "ahk",
        output_name = "app.exe",
        setup_description = "Verify Wine and AutoHotkey under Wine",
        compile_description = "Syntax-check AutoHotkey sources via Wine",
        bundle_description = "Verify AutoHotkey compile stamp",
        test_description = "Validate AutoHotkey script compilation",
        compile_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.exe",
        setup_description = "Verify Wine and AutoHotkey under Wine (debug)",
        compile_description = "Syntax-check AutoHotkey sources via Wine (verbose)",
        bundle_description = "Verify AutoHotkey debug compile stamp",
        test_description = "Validate AutoHotkey script compilation (verbose)",
        compile_args = "/verbose",
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
