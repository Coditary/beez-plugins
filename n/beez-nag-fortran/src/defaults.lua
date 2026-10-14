local M = {}

M.runnable = true

M.build_dir = "build/nag"
M.bin_dir = M.build_dir .. "/bin"
M.cmake_dir = M.build_dir .. "/cmake"
M.reports_dir = "report"

M.nagfor_binary = "nagfor"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nag-setup]"
M.log_prefix_compile = "[nag-compile]"
M.log_prefix_bundle = "[nag-bundle]"
M.log_prefix_test = "[nag-test]"

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
        scope = "nag",
        build_mode = "release",
        output_name = "app",
        fortran_std = "-f2008",
        optimize = "-O3",
        setup_description = "Prepare NAG Fortran build environment",
        compile_description = "Build with NAG Fortran (release, strict ISO)",
        bundle_description = "Verify NAG Fortran build artifacts",
        test_description = "Run Fortran tests with NAG",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        fortran_std = "-f2008",
        optimize = "-g -O0",
        setup_description = "Prepare NAG Fortran debug build environment",
        compile_description = "Build with NAG Fortran (debug, strict ISO)",
        bundle_description = "Verify NAG Fortran debug artifacts",
        test_description = "Run Fortran tests with NAG (debug)",
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
