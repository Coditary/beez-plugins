local M = {}

M.runnable = true

M.build_dir = "build/m4"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.m4_binary = "m4"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[m4-setup]"
M.log_prefix_compile = "[m4-compile]"
M.log_prefix_bundle = "[m4-bundle]"
M.log_prefix_test = "[m4-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.m4",
    "**/*.mc",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "m4",
        output_name = "app",
        setup_description = "Verify GNU m4 and prepare build directory",
        compile_description = "Compile/validate GNU m4 targets",
        bundle_description = "Verify m4 compile stamp",
        test_description = "Run primary GNU m4 target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "m4",
        output_name = "app",
        setup_description = "Verify GNU m4 and prepare build directory (debug)",
        compile_description = "Compile/validate GNU m4 targets (debug)",
        bundle_description = "Verify m4 debug compile stamp",
        test_description = "Run primary GNU m4 target (debug)",
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
