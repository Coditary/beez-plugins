local M = {}

M.runnable = true

M.build_dir = "build/rockstar"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.rockstar_binary = "rockstar"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[rockstar-setup]"
M.log_prefix_compile = "[rockstar-compile]"
M.log_prefix_bundle = "[rockstar-bundle]"
M.log_prefix_test = "[rockstar-test]"
M.log_prefix_run = "[rockstar-run]"

M.common_inputs = {
    "**/*.rock"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Rockstar runtime and prepare build directory",
        compile_description = "Validate Rockstar entry with rockstar",
        bundle_description = "Verify Rockstar compile stamp",
        test_description = "Run primary Rockstar entry",
        test_args = "",
        run_description = "Run Rockstar application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Rockstar runtime (debug)",
        compile_description = "Validate Rockstar entry with rockstar (debug)",
        bundle_description = "Verify Rockstar debug compile stamp",
        test_description = "Run primary Rockstar entry (verbose)",
        test_args = "",
        run_description = "Run Rockstar application (debug)",
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
