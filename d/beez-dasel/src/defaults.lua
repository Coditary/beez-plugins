local M = {}

M.runnable = true

M.build_dir = "build/dasel"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dasel_binary = "dasel"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[dasel-setup]"
M.log_prefix_compile = "[dasel-compile]"
M.log_prefix_bundle = "[dasel-bundle]"
M.log_prefix_test = "[dasel-test]"
M.log_prefix_run = "[dasel-run]"

M.common_inputs = {
    "**/*.toml",
    "**/*.yaml",
    "**/*.yml",
    "**/*.json",
    "**/*.xml",
    "**/*.csv"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = ".",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Dasel runtime and prepare build directory",
        compile_description = "Validate Dasel entry with dasel",
        bundle_description = "Verify Dasel compile stamp",
        test_description = "Run primary Dasel entry",
        test_args = "",
        run_description = "Run Dasel application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = ".",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Dasel runtime (debug)",
        compile_description = "Validate Dasel entry with dasel (debug)",
        bundle_description = "Verify Dasel debug compile stamp",
        test_description = "Run primary Dasel entry (verbose)",
        test_args = "",
        run_description = "Run Dasel application (debug)",
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
