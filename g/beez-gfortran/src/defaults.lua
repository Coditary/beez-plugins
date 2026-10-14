local M = {}

M.runnable = true

M.build_dir = "build/gfortran"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.gfortran_binary = "gfortran"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gfortran-setup]"
M.log_prefix_compile = "[gfortran-compile]"
M.log_prefix_bundle = "[gfortran-bundle]"
M.log_prefix_test = "[gfortran-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "CMakeLists.txt",
    "Makefile",
    "**/*.f",
    "**/*.f90",
    "**/*.f95",
}

M.build_profiles = {
    code = {
        scope = "gfortran",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        debug_info = false,
        setup_description = "Verify gfortran toolchain and prepare build directories",
        compile_description = "Compile Fortran sources with gfortran (release, -O3)",
        bundle_description = "Verify gfortran build artifacts",
        test_description = "Compile and run Fortran test programs with gfortran",
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
