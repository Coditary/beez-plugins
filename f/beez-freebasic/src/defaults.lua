local M = {}

M.runnable = true

M.build_dir = "build/freebasic"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.fbc_binary = "fbc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[freebasic-setup]"
M.log_prefix_compile = "[freebasic-compile]"
M.log_prefix_bundle = "[freebasic-bundle]"
M.log_prefix_test = "[freebasic-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bas",
}

M.build_profiles = {
    code = {
        scope = "freebasic",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify fbc FreeBASIC compiler",
        compile_description = "Compile BASIC sources with fbc",
        bundle_description = "Verify freebasic build artifacts",
        test_description = "Run freebasic tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "-g",
        setup_description = "Verify fbc FreeBASIC compiler (debug)",
        compile_description = "Compile BASIC sources with fbc (debug)",
        bundle_description = "Verify freebasic debug artifacts",
        test_description = "Run freebasic tests (verbose)",
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
