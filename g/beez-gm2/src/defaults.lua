local M = {}

M.runnable = true

M.build_dir = "build/gm2"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.gm2_binary = "gm2"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gm2-setup]"
M.log_prefix_compile = "[gm2-compile]"
M.log_prefix_bundle = "[gm2-bundle]"
M.log_prefix_test = "[gm2-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.mod",
}

M.build_profiles = {
    code = {
        scope = "gm2",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify GNU Modula-2 toolchain and prepare build directories",
        compile_description = "Compile GNU Modula-2 sources (gm2)",
        bundle_description = "Verify GNU Modula-2 build artifacts",
        test_description = "Run compiled GNU Modula-2 binary or test suite",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "gm2",
        output_name = "app",
        optimize = "-g",
        setup_description = "Verify GNU Modula-2 toolchain (debug profile)",
        compile_description = "Compile GNU Modula-2 sources with debug info",
        bundle_description = "Verify GNU Modula-2 debug build artifacts",
        test_description = "Run GNU Modula-2 tests (debug profile)",
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
