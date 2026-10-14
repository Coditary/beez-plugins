local M = {}

M.runnable = true

M.build_dir = "build/q"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.q_binary = "q"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[q-setup]"
M.log_prefix_compile = "[q-compile]"
M.log_prefix_bundle = "[q-bundle]"
M.log_prefix_test = "[q-test]"
M.log_prefix_run = "[q-run]"

M.common_inputs = {
    "**/*.q"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Q runtime and prepare build directory",
        compile_description = "Validate Q entry with q",
        bundle_description = "Verify Q compile stamp",
        test_description = "Run primary Q entry",
        test_args = "",
        run_description = "Run Q application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Q runtime (debug)",
        compile_description = "Validate Q entry with q (debug)",
        bundle_description = "Verify Q debug compile stamp",
        test_description = "Run primary Q entry (verbose)",
        test_args = "",
        run_description = "Run Q application (debug)",
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
