local M = {}

M.runnable = true

M.build_dir = "build/hare"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.hare_binary = "hare"
M.harec_binary = "harec"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[hare-setup]"
M.log_prefix_compile = "[hare-compile]"
M.log_prefix_bundle = "[hare-bundle]"
M.log_prefix_test = "[hare-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ha",
    "+layout/**",
    "+lib/**",
}

M.build_profiles = {
    code = {
        scope = "hare",
        output_name = "app",
        setup_description = "Verify Hare compiler (harec QBE backend)",
        compile_description = "Compile Hare to native code",
        bundle_description = "Verify Hare build artifacts",
        test_description = "Run Hare tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        harec_flags = "-g",
        setup_description = "Verify Hare compiler (debug)",
        compile_description = "Compile Hare to native code (debug, -g)",
        bundle_description = "Verify Hare debug artifacts",
        test_description = "Run Hare tests (verbose)",
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
