local M = {}

M.runnable = true

M.build_dir = "build/c3"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.c3c_binary = "c3c"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[c3-setup]"
M.log_prefix_compile = "[c3-compile]"
M.log_prefix_bundle = "[c3-bundle]"
M.log_prefix_test = "[c3-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "project.json",
    "**/project.json",
    "**/*.c3",
}

M.build_profiles = {
    code = {
        scope = "c3",
        output_name = "app",
        setup_description = "Verify C3 compiler (c3c LLVM backend)",
        compile_description = "Compile C3 to native code",
        bundle_description = "Verify C3 build artifacts",
        test_description = "Run C3 tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify C3 compiler (debug)",
        compile_description = "Compile C3 to native code (debug)",
        bundle_description = "Verify C3 debug artifacts",
        test_description = "Run C3 tests (verbose)",
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
