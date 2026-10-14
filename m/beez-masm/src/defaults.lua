local M = {}

M.runnable = true

M.build_dir = "build/masm"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ml_binary = "ml64"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[masm-setup]"
M.log_prefix_compile = "[masm-compile]"
M.log_prefix_bundle = "[masm-bundle]"
M.log_prefix_test = "[masm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.asm",
}

M.build_profiles = {
    code = {
        scope = "masm",
        output_name = "app",
        compile_flags = "/c",
        setup_description = "Verify ml/ml64 MASM toolchain",
        compile_description = "Assemble sources with ml/ml64",
        bundle_description = "Verify masm build artifacts",
        test_description = "Run masm tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "/c /Zi",
        setup_description = "Verify ml/ml64 MASM toolchain (debug)",
        compile_description = "Assemble sources with ml/ml64 (debug info)",
        bundle_description = "Verify masm debug artifacts",
        test_description = "Run masm tests (verbose)",
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
