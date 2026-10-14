local M = {}

M.runnable = true

M.build_dir = "build/gambit"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.gambit_binary = "gsi"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[gambit-setup]"
M.log_prefix_compile = "[gambit-compile]"
M.log_prefix_bundle = "[gambit-bundle]"
M.log_prefix_test = "[gambit-test]"
M.log_prefix_run = "[gambit-run]"

M.common_inputs = {
    "**/*.scm",
    "**/*.ss"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Gambit runtime and prepare build directory",
        compile_description = "Validate Gambit entry with gsi",
        bundle_description = "Verify Gambit compile stamp",
        test_description = "Run primary Gambit entry",
        test_args = "",
        run_description = "Run Gambit application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Gambit runtime (debug)",
        compile_description = "Validate Gambit entry with gsi (debug)",
        bundle_description = "Verify Gambit debug compile stamp",
        test_description = "Run primary Gambit entry (verbose)",
        test_args = "",
        run_description = "Run Gambit application (debug)",
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
