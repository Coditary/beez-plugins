local M = {}

M.runnable = true

M.build_dir = "build/maxima"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.maxima_binary = "maxima"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[maxima-setup]"
M.log_prefix_compile = "[maxima-compile]"
M.log_prefix_bundle = "[maxima-bundle]"
M.log_prefix_test = "[maxima-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.mac",
    "**/*.wxm",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "maxima",
        output_name = "app",
        setup_description = "Verify Maxima and prepare build directory",
        compile_description = "Compile/validate Maxima targets",
        bundle_description = "Verify maxima compile stamp",
        test_description = "Run primary Maxima target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "maxima",
        output_name = "app",
        setup_description = "Verify Maxima and prepare build directory (debug)",
        compile_description = "Compile/validate Maxima targets (debug)",
        bundle_description = "Verify maxima debug compile stamp",
        test_description = "Run primary Maxima target (debug)",
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
