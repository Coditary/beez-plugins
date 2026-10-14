local M = {}

M.runnable = true

M.build_dir = "build/act"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.act_binary = "act"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[act-setup]"
M.log_prefix_compile = "[act-compile]"
M.log_prefix_bundle = "[act-bundle]"
M.log_prefix_test = "[act-test]"
M.log_prefix_run = "[act-run]"

M.common_inputs = {
    "**/*.yml",
    "**/*.yaml",
    ".github/workflows/ci.yml",
    "**/.github/workflows/ci.yml"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "--dryrun",
        run_prefix = "",
        run_tokens = {"-W"},
        setup_description = "Verify Act runtime and prepare build directory",
        compile_description = "Validate Act entry with act",
        bundle_description = "Verify Act compile stamp",
        test_description = "Run primary Act entry",
        test_args = "",
        run_description = "Run Act application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "--dryrun",
        run_prefix = "",
        run_tokens = {"-W"},
        setup_description = "Verify Act runtime (debug)",
        compile_description = "Validate Act entry with act (debug)",
        bundle_description = "Verify Act debug compile stamp",
        test_description = "Run primary Act entry (verbose)",
        test_args = "",
        run_description = "Run Act application (debug)",
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
