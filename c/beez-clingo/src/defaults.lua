local M = {}

M.runnable = true

M.build_dir = "build/clingo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.clingo_binary = "clingo"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[clingo-setup]"
M.log_prefix_compile = "[clingo-compile]"
M.log_prefix_bundle = "[clingo-bundle]"
M.log_prefix_test = "[clingo-test]"
M.log_prefix_run = "[clingo-run]"

M.common_inputs = {
    "**/*.lp"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Clingo runtime and prepare build directory",
        compile_description = "Validate Clingo entry with clingo",
        bundle_description = "Verify Clingo compile stamp",
        test_description = "Run primary Clingo entry",
        test_args = "",
        run_description = "Run Clingo application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Clingo runtime (debug)",
        compile_description = "Validate Clingo entry with clingo (debug)",
        bundle_description = "Verify Clingo debug compile stamp",
        test_description = "Run primary Clingo entry (verbose)",
        test_args = "",
        run_description = "Run Clingo application (debug)",
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
