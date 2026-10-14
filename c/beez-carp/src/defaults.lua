local M = {}

M.runnable = true

M.build_dir = "build/carp"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.carp_binary = "carp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[carp-setup]"
M.log_prefix_compile = "[carp-compile]"
M.log_prefix_bundle = "[carp-bundle]"
M.log_prefix_test = "[carp-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Carp.toml",
    "**/Carp.toml",
    "**/*.carp",
}

M.build_profiles = {
    code = {
        scope = "carp",
        output_name = "app",
        setup_description = "Verify Carp compiler binary",
        compile_description = "Compile Carp to C and link native binary",
        bundle_description = "Verify Carp build artifacts",
        test_description = "Run Carp tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Carp compiler binary (debug)",
        compile_description = "Compile Carp to C (debug)",
        bundle_description = "Verify Carp debug artifacts",
        test_description = "Run Carp tests (verbose)",
        test_args = "",
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
