local M = {}

M.runnable = true

M.build_dir = "build/malbolge"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.malbolge_binary = "malbolge-aot"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[malbolge-setup]"
M.log_prefix_compile = "[malbolge-compile]"
M.log_prefix_bundle = "[malbolge-bundle]"
M.log_prefix_test = "[malbolge-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.mal",
}

M.build_profiles = {
    code = {
        scope = "malbolge",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify Malbolge AOT (experimental) and prepare build directory",
        compile_description = "Compile Malbolge to native binary (malbolge-aot)",
        bundle_description = "Verify Malbolge build artifacts",
        test_description = "Verify Malbolge build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "malbolge",
        output_name = "app",
        compile_flag = "-v",
        setup_description = "Verify Malbolge AOT and prepare build directory (debug)",
        compile_description = "Compile Malbolge with verbose output (malbolge-aot -v)",
        bundle_description = "Verify Malbolge debug build artifacts",
        test_description = "Verify Malbolge debug build output",
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
