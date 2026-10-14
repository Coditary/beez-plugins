local M = {}

M.runnable = true

M.build_dir = "build/duckdb"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.duckdb_binary = "duckdb"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[duckdb-setup]"
M.log_prefix_compile = "[duckdb-compile]"
M.log_prefix_bundle = "[duckdb-bundle]"
M.log_prefix_test = "[duckdb-test]"
M.log_prefix_run = "[duckdb-run]"

M.common_inputs = {
    "**/*.sql"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Duckdb runtime and prepare build directory",
        compile_description = "Validate Duckdb entry with duckdb",
        bundle_description = "Verify Duckdb compile stamp",
        test_description = "Run primary Duckdb entry",
        test_args = "",
        run_description = "Run Duckdb application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Duckdb runtime (debug)",
        compile_description = "Validate Duckdb entry with duckdb (debug)",
        bundle_description = "Verify Duckdb debug compile stamp",
        test_description = "Run primary Duckdb entry (verbose)",
        test_args = "",
        run_description = "Run Duckdb application (debug)",
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
