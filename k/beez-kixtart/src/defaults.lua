local M = {}

M.runnable = true

M.build_dir = "build/kixtart"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.wine_binary = "wine"
M.kix_binary = "kix32.exe"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[kixtart-setup]"
M.log_prefix_compile = "[kixtart-compile]"
M.log_prefix_bundle = "[kixtart-bundle]"
M.log_prefix_test = "[kixtart-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.kix",
}

M.build_profiles = {
    code = {
        scope = "kixtart",
        output_name = "app.kix",
        setup_description = "Verify Wine and KiXtart (kix32.exe)",
        compile_description = "Syntax-check KiXtart scripts via Wine kix32 /c",
        bundle_description = "Verify KiXtart compile stamp",
        test_description = "Validate KiXtart script compilation",
        compile_args = "/c",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "kixtart",
        output_name = "app.kix",
        setup_description = "Verify Wine and KiXtart under Wine (debug)",
        compile_description = "Syntax-check KiXtart scripts via Wine kix32 /c (verbose)",
        bundle_description = "Verify KiXtart debug compile stamp",
        test_description = "Validate KiXtart script compilation (verbose)",
        compile_args = "/c /d",
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
