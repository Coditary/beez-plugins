local M = {}

M.runnable = true

M.build_dir = "build/soul"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.soul_binary = "soul"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[soul-setup]"
M.log_prefix_compile = "[soul-compile]"
M.log_prefix_bundle = "[soul-bundle]"
M.log_prefix_test = "[soul-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.soul",
}

M.build_profiles = {
    code = {
        scope = "soul",
        output_name = "app.cpp",
        setup_description = "Verify SOUL compiler binary",
        compile_description = "Compile SOUL patch to C++ (AOT)",
        bundle_description = "Verify SOUL build artifacts",
        test_description = "Validate SOUL patch compilation",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.cpp",
        setup_description = "Verify SOUL compiler binary (debug)",
        compile_description = "Compile SOUL patch to C++ (debug)",
        bundle_description = "Verify SOUL debug artifacts",
        test_description = "Validate SOUL patch compilation (verbose)",
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
