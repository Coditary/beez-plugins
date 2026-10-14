local M = {}

M.runnable = true

M.build_dir = "build/vale"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.valec_binary = "valec"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[vale-setup]"
M.log_prefix_compile = "[vale-compile]"
M.log_prefix_bundle = "[vale-bundle]"
M.log_prefix_test = "[vale-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.vale",
}

M.build_profiles = {
    code = {
        scope = "vale",
        output_name = "main",
        module_name = "main",
        setup_description = "Verify Vale compiler binary",
        compile_description = "Compile Vale to native code via LLVM",
        bundle_description = "Verify Vale build artifacts",
        test_description = "Run Vale tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "main",
        module_name = "main",
        setup_description = "Verify Vale compiler binary (debug)",
        compile_description = "Compile Vale to native code (debug)",
        bundle_description = "Verify Vale debug artifacts",
        test_description = "Run Vale tests (verbose)",
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
