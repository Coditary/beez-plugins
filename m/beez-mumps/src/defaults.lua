local M = {}

M.runnable = true

M.build_dir = "build/mumps"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.mumps_binary = "mumps"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mumps-setup]"
M.log_prefix_compile = "[mumps-compile]"
M.log_prefix_bundle = "[mumps-bundle]"
M.log_prefix_test = "[mumps-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.mps",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "mumps",
        output_name = "app",
        setup_description = "Verify MUMPS and prepare build directory",
        compile_description = "Compile/validate MUMPS targets",
        bundle_description = "Verify mumps compile stamp",
        test_description = "Run primary MUMPS target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "mumps",
        output_name = "app",
        setup_description = "Verify MUMPS and prepare build directory (debug)",
        compile_description = "Compile/validate MUMPS targets (debug)",
        bundle_description = "Verify mumps debug compile stamp",
        test_description = "Run primary MUMPS target (debug)",
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
