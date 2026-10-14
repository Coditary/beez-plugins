local M = {}

M.runnable = true

M.build_dir = "build/ibmasm"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.hlasm_binary = "hlasm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ibmasm-setup]"
M.log_prefix_compile = "[ibmasm-compile]"
M.log_prefix_bundle = "[ibmasm-bundle]"
M.log_prefix_test = "[ibmasm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.asm",
    "**/*.mac",
}

M.build_profiles = {
    code = {
        scope = "ibmasm",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify HLASM (IBM Basic Assembly) toolchain",
        compile_description = "Assemble IBM HLASM sources (*.asm, *.mac)",
        bundle_description = "Verify HLASM build artifacts",
        test_description = "Run HLASM compile smoke test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "ibmasm",
        output_name = "app",
        compile_flags = "-LIST",
        setup_description = "Verify HLASM toolchain (debug)",
        compile_description = "Assemble IBM HLASM sources with listing output",
        bundle_description = "Verify HLASM debug build artifacts",
        test_description = "Run HLASM tests (verbose)",
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
