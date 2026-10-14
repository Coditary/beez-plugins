local M = {}

M.runnable = true

M.build_dir = "build/dylan"
M.bin_dir = "_build/bin"
M.reports_dir = "report"

M.dylan_binary = "dylan-compiler"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dylan-setup]"
M.log_prefix_compile = "[dylan-compile]"
M.log_prefix_bundle = "[dylan-bundle]"
M.log_prefix_test = "[dylan-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.dylan",
    "**/*.lid",
}

M.build_profiles = {
    code = {
        scope = "dylan",
        output_name = "app",
        setup_description = "Verify Open Dylan compiler and prepare build directory",
        compile_description = "Compile Dylan sources with dylan-compiler -build",
        bundle_description = "Verify Open Dylan build artifacts in _build/bin",
        test_description = "Run Dylan project tests when present",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "dylan",
        output_name = "app",
        setup_description = "Verify Open Dylan compiler (debug)",
        compile_description = "Compile Dylan sources with dylan-compiler -build (debug)",
        bundle_description = "Verify Open Dylan debug build artifacts",
        test_description = "Run Dylan tests (verbose)",
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
