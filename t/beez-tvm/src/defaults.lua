local M = {}

M.runnable = false

M.build_dir = "build/tvm"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.python_binary = "python3"
M.pip_binary = "pip3"
M.tvm_target = "llvm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tvm-setup]"
M.log_prefix_compile = "[tvm-compile]"
M.log_prefix_bundle = "[tvm-bundle]"
M.log_prefix_test = "[tvm-test]"


M.common_inputs = {
    "**/*.relay",
    "**/*.tir",
    "**/*compile*.py",
    "**/*tvm*.py",
    "requirements.txt",
    "**/requirements.txt",
}

M.build_profiles = {
    code = {
        scope = "tvm",
        output_name = "model.so",
        setup_description = "Install Apache TVM deep learning compiler",
        compile_description = "Compile Relay/TIR models to native code via TVM",
        bundle_description = "Verify TVM native code artifacts",
        test_description = "Validate TVM compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "model_debug.so",
        setup_description = "Install Apache TVM (debug)",
        compile_description = "Compile Relay/TIR via TVM with debug output",
        bundle_description = "Verify TVM debug artifacts",
        test_description = "Validate TVM compilation (verbose)",
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
