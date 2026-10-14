local M = {}

M.runnable = true

M.build_dir = "build/odin"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.odin_binary = "odin"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[odin-setup]"
M.log_prefix_compile = "[odin-compile]"
M.log_prefix_bundle = "[odin-bundle]"
M.log_prefix_test = "[odin-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.odin",
    "**/build.odin",
    "**/*.odin",
}

M.build_profiles = {
    code = {
        scope = "odin",
        output_name = "app",
        setup_description = "Verify Odin compiler binary",
        compile_description = "Compile Odin to native code",
        bundle_description = "Verify Odin build artifacts",
        test_description = "Run Odin tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Odin compiler binary (debug)",
        compile_description = "Compile Odin to native code (debug)",
        bundle_description = "Verify Odin debug artifacts",
        test_description = "Run Odin tests (verbose)",
        test_args = "-verbose",
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
