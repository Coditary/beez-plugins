local M = {}

M.runnable = true

M.build_dir = "build/inko"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.inko_binary = "inko"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[inko-setup]"
M.log_prefix_compile = "[inko-compile]"
M.log_prefix_bundle = "[inko-bundle]"
M.log_prefix_test = "[inko-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.inko",
}

M.build_profiles = {
    code = {
        scope = "inko",
        output_name = "app",
        release_flag = "--release",
        inko_build_dir = "build/release",
        setup_description = "Verify Inko compiler (LLVM ownership)",
        compile_description = "Compile Inko to native executable",
        bundle_description = "Verify Inko build artifacts",
        test_description = "Run Inko tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        release_flag = "",
        inko_build_dir = "build/debug",
        setup_description = "Verify Inko compiler (debug)",
        compile_description = "Compile Inko to native executable (debug)",
        bundle_description = "Verify Inko debug build artifacts",
        test_description = "Run Inko tests (verbose)",
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
