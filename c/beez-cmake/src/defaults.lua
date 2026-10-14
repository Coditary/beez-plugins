local M = {}

M.runnable = false

M.build_dir = "build/cmake"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.cmake_binary = "cmake"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cmake-setup]"
M.log_prefix_compile = "[cmake-compile]"
M.log_prefix_bundle = "[cmake-bundle]"
M.log_prefix_test = "[cmake-test]"


M.common_inputs = {
    "CMakeLists.txt",
    "**/CMakeLists.txt",
}

M.build_profiles = {
    code = {
        scope = "cmake",
        output_name = "build.ok",
        setup_description = "Verify CMake CLI and configure build directory",
        compile_description = "Build CMake project targets",
        bundle_description = "Verify CMake build artifacts",
        test_description = "Run CTest suite for CMake project",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        setup_description = "Verify CMake CLI and configure debug build",
        compile_description = "Build CMake project with debug configuration",
        bundle_description = "Verify CMake debug build artifacts",
        test_description = "Run CTest suite (verbose)",
        test_args = "-V",
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


return M
