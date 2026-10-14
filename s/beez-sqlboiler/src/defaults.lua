local M = {}

M.runnable = false

M.build_dir = "build/sqlboiler"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.sqlboiler_binary = "sqlboiler"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sqlboiler-setup]"
M.log_prefix_compile = "[sqlboiler-compile]"
M.log_prefix_bundle = "[sqlboiler-bundle]"
M.log_prefix_test = "[sqlboiler-test]"


M.common_inputs = {
    "sqlboiler.toml",
    "**/sqlboiler.toml",
    "go.mod",
    "**/go.mod",
}

M.build_profiles = {
    code = {
        scope = "sqlboiler",
        output_name = "generate.ok",
        db_driver = "psql",
        setup_description = "Verify SQLBoiler CLI and configuration",
        compile_description = "Generate Go ORM models with SQLBoiler",
        bundle_description = "Verify SQLBoiler generated model artifacts",
        test_description = "Build and validate SQLBoiler generated packages",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "generate.ok",
        db_driver = "psql",
        setup_description = "Verify SQLBoiler CLI (debug)",
        compile_description = "Generate SQLBoiler models with verbose output (debug)",
        bundle_description = "Verify SQLBoiler debug generated artifacts",
        test_description = "Build SQLBoiler packages (verbose)",
        test_args = "-v",
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


return M
