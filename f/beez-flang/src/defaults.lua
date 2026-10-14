local M = {}

M.runnable = true

M.build_dir = "build/flang"
M.bin_dir = M.build_dir .. "/bin"
M.cmake_dir = M.build_dir .. "/cmake"
M.reports_dir = "report"

M.flang_binary = "flang-new"
M.flang_binary_fallback = "flang"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[flang-setup]"
M.log_prefix_compile = "[flang-compile]"
M.log_prefix_bundle = "[flang-bundle]"
M.log_prefix_test = "[flang-test]"

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
        scope = "flang",
        build_mode = "release",
        output_name = "app",
        optimize = "-O2",
        debug_flags = "",
        cmake_build_type = "Release",
        setup_description = "Prepare LLVM Flang build environment",
        compile_description = "Build with LLVM Flang (release, -O2)",
        bundle_description = "Verify Flang build artifacts",
        test_description = "Run Fortran tests with Flang",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "flang",
        build_mode = "debug",
        output_name = "app",
        optimize = "",
        debug_flags = "-g",
        cmake_build_type = "Debug",
        setup_description = "Prepare LLVM Flang debug build environment",
        compile_description = "Build with LLVM Flang (debug, -g)",
        bundle_description = "Verify Flang debug build artifacts",
        test_description = "Run Fortran tests with Flang (debug)",
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
