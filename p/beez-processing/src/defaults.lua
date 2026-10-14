local M = {}

M.runnable = false

M.build_dir = "build/processing"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.processing_java_binary = "processing-java"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[processing-setup]"
M.log_prefix_compile = "[processing-compile]"
M.log_prefix_bundle = "[processing-bundle]"
M.log_prefix_test = "[processing-test]"


M.common_inputs = {
    "**/*.pde",
}

M.build_profiles = {
    code = {
        scope = "processing",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify Processing toolchain and prepare build directories",
        compile_description = "Compile Processing sources (processing)",
        bundle_description = "Verify Processing build artifacts",
        test_description = "Run compiled Processing binary or test suite",
        test_args = "",
    },

    debug = {
        scope = "processing",
        output_name = "app",
        optimize = "-g",
        setup_description = "Verify Processing toolchain (debug profile)",
        compile_description = "Compile Processing sources with debug info",
        bundle_description = "Verify Processing debug build artifacts",
        test_description = "Run Processing tests (debug profile)",
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
