local M = {}

M.runnable = true

M.build_dir = "build/nekovm"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.nekovm_binary = "neko"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[nekovm-setup]"
M.log_prefix_compile = "[nekovm-compile]"
M.log_prefix_bundle = "[nekovm-bundle]"
M.log_prefix_test = "[nekovm-test]"
M.log_prefix_run = "[nekovm-run]"

M.common_inputs = {
    "**/*.n"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Nekovm runtime and prepare build directory",
        compile_description = "Validate Nekovm entry with neko",
        bundle_description = "Verify Nekovm compile stamp",
        test_description = "Run primary Nekovm entry",
        test_args = "",
        run_description = "Run Nekovm application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Nekovm runtime (debug)",
        compile_description = "Validate Nekovm entry with neko (debug)",
        bundle_description = "Verify Nekovm debug compile stamp",
        test_description = "Run primary Nekovm entry (verbose)",
        test_args = "",
        run_description = "Run Nekovm application (debug)",
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
