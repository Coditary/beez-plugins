local M = {}

M.runnable = false

M.build_dir = "build/glslang"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.glslang_binary = "glslangValidator"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[glslang-setup]"
M.log_prefix_compile = "[glslang-compile]"
M.log_prefix_bundle = "[glslang-bundle]"
M.log_prefix_test = "[glslang-test]"


M.common_inputs = {
    "**/*.glsl",
    "**/*.vert",
    "**/*.frag",
}

M.build_profiles = {
    code = {
        scope = "glslang",
        output_name = "app",
        setup_description = "Verify glslangValidator binary and prepare build directory",
        compile_description = "Compile GLSL shaders to SPIR-V with glslangValidator -V",
        bundle_description = "Verify SPIR-V shader artifacts",
        test_description = "Verify SPIR-V outputs exist",
        test_args = "",
    },

    debug = {
        scope = "glslang",
        output_name = "app",
        setup_description = "Verify glslangValidator binary and prepare build directory (debug)",
        compile_description = "Compile GLSL shaders to SPIR-V with glslangValidator -V (debug)",
        bundle_description = "Verify SPIR-V shader artifacts (debug)",
        test_description = "Verify SPIR-V outputs exist (verbose)",
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
