local M = {}

M.runnable = true

M.build_dir = "build/gas"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.as_binary = "as"
M.gcc_binary = "gcc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gas-setup]"
M.log_prefix_compile = "[gas-compile]"
M.log_prefix_bundle = "[gas-bundle]"
M.log_prefix_test = "[gas-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.s",
    "**/*.S",
}

M.build_profiles = {
    code = {
        scope = "gas",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify GNU as/gcc assembler toolchain",
        compile_description = "Assemble sources with as/gcc -c",
        bundle_description = "Verify gas build artifacts",
        test_description = "Run gas tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "-g",
        setup_description = "Verify GNU as/gcc assembler toolchain (debug)",
        compile_description = "Assemble sources with as/gcc -c (debug)",
        bundle_description = "Verify gas debug artifacts",
        test_description = "Run gas tests (verbose)",
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
