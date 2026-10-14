local M = {}

M.runnable = true

M.build_dir = "build/minizinc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.minizinc_binary = "minizinc"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[minizinc-setup]"
M.log_prefix_compile = "[minizinc-compile]"
M.log_prefix_bundle = "[minizinc-bundle]"
M.log_prefix_test = "[minizinc-test]"
M.log_prefix_run = "[minizinc-run]"

M.common_inputs = {
    "**/*.mzn"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {"--solver", "gecode"},
        setup_description = "Verify Minizinc runtime and prepare build directory",
        compile_description = "Validate Minizinc entry with minizinc",
        bundle_description = "Verify Minizinc compile stamp",
        test_description = "Run primary Minizinc entry",
        test_args = "",
        run_description = "Run Minizinc application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {"--solver", "gecode"},
        setup_description = "Verify Minizinc runtime (debug)",
        compile_description = "Validate Minizinc entry with minizinc (debug)",
        bundle_description = "Verify Minizinc debug compile stamp",
        test_description = "Run primary Minizinc entry (verbose)",
        test_args = "",
        run_description = "Run Minizinc application (debug)",
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
