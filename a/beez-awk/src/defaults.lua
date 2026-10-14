local M = {}

M.runnable = true

M.build_dir = "build/awk"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.gawk_binary = "gawk"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[awk-setup]"
M.log_prefix_compile = "[awk-compile]"
M.log_prefix_bundle = "[awk-bundle]"
M.log_prefix_test = "[awk-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.awk",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "awk",
        output_name = "app",
        setup_description = "Verify gawk and prepare build directory",
        compile_description = "Lint-check AWK sources with gawk --lint",
        bundle_description = "Verify AWK compile stamp",
        test_description = "Run primary AWK script with gawk",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "awk",
        output_name = "app",
        setup_description = "Verify gawk and prepare build directory (debug)",
        compile_description = "Lint-check AWK sources with gawk --lint (verbose)",
        bundle_description = "Verify AWK debug compile stamp",
        test_description = "Run primary AWK script with gawk (verbose)",
        test_args = "-W debug",
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
