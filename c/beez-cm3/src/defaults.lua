local M = {}

M.runnable = true

M.build_dir = "build/cm3"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.cm3_binary = "cm3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cm3-setup]"
M.log_prefix_compile = "[cm3-compile]"
M.log_prefix_bundle = "[cm3-bundle]"
M.log_prefix_test = "[cm3-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.i3",
    "**/*.m3",
}

M.build_profiles = {
    code = {
        scope = "cm3",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify Critical Mass Modula-3 toolchain and prepare build directories",
        compile_description = "Compile Critical Mass Modula-3 sources (cm3)",
        bundle_description = "Verify Critical Mass Modula-3 build artifacts",
        test_description = "Run compiled Critical Mass Modula-3 binary or test suite",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "cm3",
        output_name = "app",
        optimize = "-g",
        setup_description = "Verify Critical Mass Modula-3 toolchain (debug profile)",
        compile_description = "Compile Critical Mass Modula-3 sources with debug info",
        bundle_description = "Verify Critical Mass Modula-3 debug build artifacts",
        test_description = "Run Critical Mass Modula-3 tests (debug profile)",
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
