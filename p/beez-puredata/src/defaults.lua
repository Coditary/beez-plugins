local M = {}

M.runnable = true

M.build_dir = "build/puredata"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.pd_binary = "pd"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[puredata-setup]"
M.log_prefix_compile = "[puredata-compile]"
M.log_prefix_bundle = "[puredata-bundle]"
M.log_prefix_test = "[puredata-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.pd",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "puredata",
        output_name = "app",
        setup_description = "Verify Pure Data and prepare build directory",
        compile_description = "Compile/validate Pure Data targets",
        bundle_description = "Verify puredata compile stamp",
        test_description = "Run primary Pure Data target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "puredata",
        output_name = "app",
        setup_description = "Verify Pure Data and prepare build directory (debug)",
        compile_description = "Compile/validate Pure Data targets (debug)",
        bundle_description = "Verify puredata debug compile stamp",
        test_description = "Run primary Pure Data target (debug)",
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
