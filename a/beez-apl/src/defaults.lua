local M = {}

M.runnable = true

M.build_dir = "build/apl"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.apl_binary = "apl"
M.dyalog_binary = "dyalog"
M.apl_flavor = "gnu"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[apl-setup]"
M.log_prefix_compile = "[apl-compile]"
M.log_prefix_bundle = "[apl-bundle]"
M.log_prefix_test = "[apl-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.apl",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "apl",
        output_name = "app",
        setup_description = "Verify GNU APL or Dyalog and prepare build directory",
        compile_description = "Load-check APL sources with apl or dyalog",
        bundle_description = "Verify APL compile stamp",
        test_description = "Run primary APL script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "apl",
        output_name = "app",
        setup_description = "Verify GNU APL or Dyalog and prepare build directory (debug)",
        compile_description = "Load-check APL sources with apl or dyalog (debug)",
        bundle_description = "Verify APL debug compile stamp",
        test_description = "Run primary APL script (verbose)",
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
