local M = {}

M.runnable = false

M.build_dir = "build/halide"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.cxx_binary = "g++"
M.halide_generator_binary = "halide_generator"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[halide-setup]"
M.log_prefix_compile = "[halide-compile]"
M.log_prefix_bundle = "[halide-bundle]"
M.log_prefix_test = "[halide-test]"


M.common_inputs = {
    "**/*.generator.cpp",
    "**/pipeline.cpp",
}

M.build_profiles = {
    code = {
        scope = "halide",
        output_name = "app",
        setup_description = "Verify C++ compiler and Halide headers, prepare build directory",
        compile_description = "Build Halide generator and compile AOT pipeline",
        bundle_description = "Verify Halide static library artifacts",
        test_description = "Verify Halide build outputs exist",
        test_args = "",
    },

    debug = {
        scope = "halide",
        output_name = "app",
        setup_description = "Verify C++ compiler and Halide headers, prepare build directory (debug)",
        compile_description = "Build Halide generator and compile AOT pipeline (debug)",
        bundle_description = "Verify Halide static library artifacts (debug)",
        test_description = "Verify Halide build outputs exist (verbose)",
        test_args = "-v",
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
