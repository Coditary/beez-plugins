local M = {}

M.runnable = false

M.build_dir = "build/dex"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.python_binary = "python3"
M.pip_binary = "pip3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dex-setup]"
M.log_prefix_compile = "[dex-compile]"
M.log_prefix_bundle = "[dex-bundle]"
M.log_prefix_test = "[dex-test]"


M.common_inputs = {
    "**/*.dex",
}

M.build_profiles = {
    code = {
        scope = "dex",
        output_name = "app",
        setup_description = "Verify Dex/JAX Python environment",
        compile_description = "Compile Dex to LLVM IR",
        bundle_description = "Verify Dex build artifacts",
        test_description = "Run Dex tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Dex/JAX Python environment (debug)",
        compile_description = "Compile Dex to LLVM IR (debug)",
        bundle_description = "Verify Dex debug artifacts",
        test_description = "Run Dex tests (verbose)",
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
