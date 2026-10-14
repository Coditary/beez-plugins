local M = {}

M.runnable = true

M.build_dir = "build/squirrel"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.squirrel_binary = "squirrel"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[squirrel-setup]"
M.log_prefix_compile = "[squirrel-compile]"
M.log_prefix_bundle = "[squirrel-bundle]"
M.log_prefix_test = "[squirrel-test]"
M.log_prefix_run = "[squirrel-run]"

M.common_inputs = {
    "**/*.nut"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Squirrel runtime and prepare build directory",
        compile_description = "Validate Squirrel entry with squirrel",
        bundle_description = "Verify Squirrel compile stamp",
        test_description = "Run primary Squirrel entry",
        test_args = "",
        run_description = "Run Squirrel application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Squirrel runtime (debug)",
        compile_description = "Validate Squirrel entry with squirrel (debug)",
        bundle_description = "Verify Squirrel debug compile stamp",
        test_description = "Run primary Squirrel entry (verbose)",
        test_args = "",
        run_description = "Run Squirrel application (debug)",
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
