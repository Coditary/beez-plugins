local M = {}

M.runnable = true

M.build_dir = "build/z3"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.z3_binary = "z3"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[z3-setup]"
M.log_prefix_compile = "[z3-compile]"
M.log_prefix_bundle = "[z3-bundle]"
M.log_prefix_test = "[z3-test]"
M.log_prefix_run = "[z3-run]"

M.common_inputs = {
    "**/*.smt2",
    "**/*.smt"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Z3 runtime and prepare build directory",
        compile_description = "Validate Z3 entry with z3",
        bundle_description = "Verify Z3 compile stamp",
        test_description = "Run primary Z3 entry",
        test_args = "",
        run_description = "Run Z3 application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Z3 runtime (debug)",
        compile_description = "Validate Z3 entry with z3 (debug)",
        bundle_description = "Verify Z3 debug compile stamp",
        test_description = "Run primary Z3 entry (verbose)",
        test_args = "",
        run_description = "Run Z3 application (debug)",
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
