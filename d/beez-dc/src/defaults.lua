local M = {}

M.runnable = true

M.build_dir = "build/dc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dc_binary = "dc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dc-setup]"
M.log_prefix_compile = "[dc-compile]"
M.log_prefix_bundle = "[dc-bundle]"
M.log_prefix_test = "[dc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.dc",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "dc",
        output_name = "app",
        setup_description = "Verify dc and prepare build directory",
        compile_description = "Parse dc scripts with dc -f",
        bundle_description = "Verify dc compile stamp",
        test_description = "Run primary dc script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "dc",
        output_name = "app",
        setup_description = "Verify dc and prepare build directory (debug)",
        compile_description = "Parse dc scripts with dc -f (debug)",
        bundle_description = "Verify dc debug compile stamp",
        test_description = "Run primary dc script (verbose)",
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
