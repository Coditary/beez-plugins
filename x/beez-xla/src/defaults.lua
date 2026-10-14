local M = {}

M.runnable = false

M.build_dir = "build/xla"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.xla_opt_binary = "xla-opt"
M.mlir_opt_binary = "mlir-opt"
M.python_binary = "python3"
M.pip_binary = "pip3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[xla-setup]"
M.log_prefix_compile = "[xla-compile]"
M.log_prefix_bundle = "[xla-bundle]"
M.log_prefix_test = "[xla-test]"


M.common_inputs = {
    "**/*.mlir",
    "xla_config.json",
    "**/xla_config.json",
    "**/xla/*.json",
    "saved_model.pb",
    "**/saved_model.pb",
    "**/saved_model/**",
    "**/*xla*.py",
}

M.build_profiles = {
    code = {
        scope = "xla",
        output_name = "output.mlir",
        entry_kind = "mlir",
        setup_description = "Install XLA/TensorFlow ML compiler dependencies",
        compile_description = "Compile MLIR or SavedModel via XLA tools",
        bundle_description = "Verify XLA compilation artifacts",
        test_description = "Validate XLA compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "output_debug.mlir",
        entry_kind = "mlir",
        setup_description = "Install XLA dependencies (debug)",
        compile_description = "Compile MLIR via XLA with debug output",
        bundle_description = "Verify XLA debug artifacts",
        test_description = "Validate XLA compilation (verbose)",
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
