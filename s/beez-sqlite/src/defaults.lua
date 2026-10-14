local M = {}

M.runnable = true

M.build_dir = "build/sqlite"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.sqlite3_binary = "sqlite3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sqlite-setup]"
M.log_prefix_compile = "[sqlite-compile]"
M.log_prefix_bundle = "[sqlite-bundle]"
M.log_prefix_test = "[sqlite-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.sql",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "sqlite",
        output_name = "app",
        setup_description = "Verify SQLite SQL and prepare build directory",
        compile_description = "Compile/validate SQLite SQL targets",
        bundle_description = "Verify sqlite compile stamp",
        test_description = "Run primary SQLite SQL target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "sqlite",
        output_name = "app",
        setup_description = "Verify SQLite SQL and prepare build directory (debug)",
        compile_description = "Compile/validate SQLite SQL targets (debug)",
        bundle_description = "Verify sqlite debug compile stamp",
        test_description = "Run primary SQLite SQL target (debug)",
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
