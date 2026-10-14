local M = {}

M.runnable = true

M.build_dir = "build/koka"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.koka_binary = "koka"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[koka-setup]"
M.log_prefix_compile = "[koka-compile]"
M.log_prefix_bundle = "[koka-bundle]"
M.log_prefix_test = "[koka-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "package.toml",
    "**/package.toml",
    "**/*.kk",
}

M.build_profiles = {
    code = {
        scope = "koka",
        output_name = "app",
        setup_description = "Verify Koka compiler binary",
        compile_description = "Compile Koka to native code via C backend",
        bundle_description = "Verify Koka build artifacts",
        test_description = "Run Koka tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Koka compiler binary (debug)",
        compile_description = "Compile Koka to native code (debug)",
        bundle_description = "Verify Koka debug artifacts",
        test_description = "Run Koka tests (verbose)",
        test_args = "-verbose",
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
