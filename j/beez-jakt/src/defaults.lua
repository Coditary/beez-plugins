local M = {}

M.runnable = true

M.build_dir = "build/jakt"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.jakt_binary = "jakt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jakt-setup]"
M.log_prefix_compile = "[jakt-compile]"
M.log_prefix_bundle = "[jakt-bundle]"
M.log_prefix_test = "[jakt-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.jakt",
}

M.build_profiles = {
    code = {
        scope = "jakt",
        output_name = "app",
        setup_description = "Verify Jakt compiler binary",
        compile_description = "Compile Jakt to native code via C++ backend",
        bundle_description = "Verify Jakt build artifacts",
        test_description = "Run Jakt tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Jakt compiler binary (debug)",
        compile_description = "Compile Jakt to native code (debug)",
        bundle_description = "Verify Jakt debug artifacts",
        test_description = "Run Jakt tests (verbose)",
        test_args = "",
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
