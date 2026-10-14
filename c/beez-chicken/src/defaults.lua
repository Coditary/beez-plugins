local M = {}

M.runnable = true

M.build_dir = "build/chicken"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.csc_binary = "csc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[chicken-setup]"
M.log_prefix_compile = "[chicken-compile]"
M.log_prefix_bundle = "[chicken-bundle]"
M.log_prefix_test = "[chicken-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.scm",
    "**/*.scm",
    "*.setup",
}

M.build_profiles = {
    code = {
        scope = "chicken",
        optimize = "-O3",
        output_name = "app",
        setup_description = "Verify csc and prepare build directory",
        compile_description = "Compile Scheme sources to native binary (csc)",
        bundle_description = "Verify compiled Chicken binaries",
        test_description = "Run compiled Chicken binary",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "chicken",
        optimize = "-debug",
        output_name = "app",
        setup_description = "Verify csc and prepare build directory (debug)",
        compile_description = "Compile Scheme sources with debug info (csc -debug)",
        bundle_description = "Verify compiled Chicken debug binaries",
        test_description = "Run compiled Chicken binary (verbose)",
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
