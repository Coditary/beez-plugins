local M = {}

M.runnable = true

M.build_dir = "build/nu"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.nu_binary = "nu"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[nu-setup]"
M.log_prefix_compile = "[nu-compile]"
M.log_prefix_bundle = "[nu-bundle]"
M.log_prefix_test = "[nu-test]"
M.log_prefix_run = "[nu-run]"

M.common_inputs = {
    "**/*.nu"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Nu runtime and prepare build directory",
        compile_description = "Validate Nu entry with nu",
        bundle_description = "Verify Nu compile stamp",
        test_description = "Run primary Nu entry",
        test_args = "",
        run_description = "Run Nu application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Nu runtime (debug)",
        compile_description = "Validate Nu entry with nu (debug)",
        bundle_description = "Verify Nu debug compile stamp",
        test_description = "Run primary Nu entry (verbose)",
        test_args = "",
        run_description = "Run Nu application (debug)",
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
