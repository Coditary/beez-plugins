local M = {}

M.runnable = true

M.build_dir = "build/jess"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.jess_binary = "jess"
M.java_binary = "java"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jess-setup]"
M.log_prefix_compile = "[jess-compile]"
M.log_prefix_bundle = "[jess-bundle]"
M.log_prefix_test = "[jess-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.clp",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "jess",
        output_name = "app",
        setup_description = "Verify jess/java and prepare build directory",
        compile_description = "Load and validate Jess CLP sources in batch mode",
        bundle_description = "Verify jess compile stamp",
        test_description = "Run primary Jess CLP script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jess",
        output_name = "app",
        setup_description = "Verify jess/java and prepare build directory (debug)",
        compile_description = "Load and validate Jess CLP sources in batch mode (debug)",
        bundle_description = "Verify jess debug compile stamp",
        test_description = "Run primary Jess CLP script (verbose)",
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
