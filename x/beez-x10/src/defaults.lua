local M = {}

M.runnable = true

M.build_dir = "build/x10"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.x10c_binary = "x10c"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[x10-setup]"
M.log_prefix_compile = "[x10-compile]"
M.log_prefix_bundle = "[x10-bundle]"
M.log_prefix_test = "[x10-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "X10.properties",
    "**/X10.properties",
    "**/*.x10",
}

M.compile_exclude = [[/(\.git|build|x10rt)/]]

M.build_profiles = {
    code = {
        scope = "x10",
        output_name = "app",
        setup_description = "Verify x10c JVM compiler and X10.properties",
        compile_description = "Compile X10 sources with x10c (JVM backend)",
        bundle_description = "Verify X10 compile stamp",
        test_description = "Run X10 unit tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "x10",
        output_name = "app",
        setup_description = "Verify x10c JVM compiler (debug)",
        compile_description = "Compile X10 sources with x10c (debug)",
        bundle_description = "Verify X10 debug compile stamp",
        test_description = "Run X10 unit tests (verbose)",
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
