local M = {}

M.runnable = true

M.build_dir = "build/brainfuck"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.bfc_binary = "bfc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[brainfuck-setup]"
M.log_prefix_compile = "[brainfuck-compile]"
M.log_prefix_bundle = "[brainfuck-bundle]"
M.log_prefix_test = "[brainfuck-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bf",
    "**/*.b",
}

M.build_profiles = {
    code = {
        scope = "brainfuck",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify bfc (AOT x86-64) and prepare build directory",
        compile_description = "Compile Brainfuck to native x86-64 binary (bfc)",
        bundle_description = "Verify Brainfuck build artifacts",
        test_description = "Verify Brainfuck build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "brainfuck",
        output_name = "app",
        compile_flag = "-a",
        setup_description = "Verify bfc and prepare build directory (debug)",
        compile_description = "Compile Brainfuck with annotated output (bfc -a)",
        bundle_description = "Verify Brainfuck debug build artifacts",
        test_description = "Verify Brainfuck debug build output",
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
