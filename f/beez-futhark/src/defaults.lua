local M = {}

M.runnable = true

M.build_dir = "build/futhark"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.futhark_binary = "futhark"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[futhark-setup]"
M.log_prefix_compile = "[futhark-compile]"
M.log_prefix_bundle = "[futhark-bundle]"
M.log_prefix_test = "[futhark-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.fut",
}

M.build_profiles = {
    code = {
        scope = "futhark",
        output_name = "app",
        backend = "c",
        setup_description = "Verify Futhark compiler (C backend)",
        compile_description = "Compile Futhark to C via futhark c",
        bundle_description = "Verify Futhark build artifacts",
        test_description = "Run Futhark tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        backend = "opencl",
        setup_description = "Verify Futhark compiler (OpenCL backend)",
        compile_description = "Compile Futhark to OpenCL via futhark opencl",
        bundle_description = "Verify Futhark debug artifacts",
        test_description = "Run Futhark tests (verbose)",
        test_args = "-v",
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
