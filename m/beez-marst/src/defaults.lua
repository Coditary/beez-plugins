local M = {}

M.runnable = true

M.build_dir = "build/marst"
M.bin_dir = M.build_dir .. "/bin"
M.gen_dir = M.build_dir .. "/gen"
M.reports_dir = "report"

M.marst_binary = "marst"
M.gcc_binary = "gcc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[marst-setup]"
M.log_prefix_compile = "[marst-compile]"
M.log_prefix_bundle = "[marst-bundle]"
M.log_prefix_test = "[marst-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.alg",
}

M.build_profiles = {
    code = {
        scope = "marst",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify marst ALGOL 60 to C translator and gcc",
        compile_description = "Translate ALGOL 60 sources with marst and link with gcc",
        bundle_description = "Verify marst build artifacts",
        test_description = "Run marst compile smoke test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "marst",
        output_name = "app",
        compile_flags = "-d",
        setup_description = "Verify marst translator (debug)",
        compile_description = "Translate ALGOL 60 sources with marst (debug comments)",
        bundle_description = "Verify marst debug C artifacts",
        test_description = "Run marst tests (verbose)",
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
