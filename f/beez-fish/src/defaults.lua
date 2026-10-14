local M = {}

M.runnable = true

M.build_dir = "build/fish"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.fish_binary = "fish"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fish-setup]"
M.log_prefix_compile = "[fish-compile]"
M.log_prefix_bundle = "[fish-bundle]"
M.log_prefix_test = "[fish-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.fish",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "fish",
        output_name = "app",
        setup_description = "Verify fish and prepare build directory",
        compile_description = "Syntax-check fish scripts with fish -n",
        bundle_description = "Verify fish compile stamp",
        test_description = "Run primary fish script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "fish",
        output_name = "app",
        setup_description = "Verify fish and prepare build directory (debug)",
        compile_description = "Syntax-check fish scripts with fish -n (debug)",
        bundle_description = "Verify fish debug compile stamp",
        test_description = "Run primary fish script (verbose)",
        test_args = "-d",
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
