local M = {}

M.runnable = false

M.build_dir = "build/catala"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.catala_binary = "catala"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[catala-setup]"
M.log_prefix_compile = "[catala-compile]"
M.log_prefix_bundle = "[catala-bundle]"
M.log_prefix_test = "[catala-test]"


M.common_inputs = {
    "**/*.catala",
}

M.build_profiles = {
    code = {
        scope = "catala",
        output_name = "output.c",
        target_backend = "C",
        setup_description = "Verify Catala computational law compiler",
        compile_description = "Compile Catala sources to C",
        bundle_description = "Verify Catala build artifacts",
        test_description = "Validate Catala compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "output.py",
        target_backend = "Python",
        setup_description = "Verify Catala compiler (debug)",
        compile_description = "Compile Catala sources to Python",
        bundle_description = "Verify Catala debug artifacts",
        test_description = "Validate Catala compilation (verbose)",
        test_args = "--verbose",
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
