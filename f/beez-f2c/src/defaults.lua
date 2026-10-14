local M = {}

M.runnable = true

M.build_dir = "build/f2c"
M.bin_dir = M.build_dir .. "/bin"
M.gen_dir = M.build_dir .. "/gen"
M.reports_dir = "report"

M.f2c_binary = "f2c"
M.gcc_binary = "gcc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[f2c-setup]"
M.log_prefix_compile = "[f2c-compile]"
M.log_prefix_bundle = "[f2c-bundle]"
M.log_prefix_test = "[f2c-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "CMakeLists.txt",
    "Makefile",
    "**/*.f",
    "**/*.for",
}

M.build_profiles = {
    code = {
        scope = "f2c",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        debug_info = false,
        setup_description = "Verify f2c and gcc toolchain and prepare build directories",
        compile_description = "Transpile Fortran with f2c and compile generated C with gcc",
        bundle_description = "Verify f2c build artifacts",
        test_description = "Transpile, compile, and run Fortran test programs via f2c + gcc",
        run_description = "Run application (code)",
    },
    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        optimize = false,
        debug_info = true,
        setup_description = "Verify toolchain and prepare build directories (debug)",
        compile_description = "Compile sources (debug, -g -O0)",
        bundle_description = "Verify debug build artifacts",
        test_description = "Compile and run test programs (debug, verbose)",
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
