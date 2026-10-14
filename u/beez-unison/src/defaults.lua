local M = {}

M.runnable = true

M.build_dir = "build/unison"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.unison_binary = "ucm"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[unison-setup]"
M.log_prefix_compile = "[unison-compile]"
M.log_prefix_bundle = "[unison-bundle]"
M.log_prefix_test = "[unison-test]"
M.log_prefix_run = "[unison-run]"

M.common_inputs = {
    "**/*.u"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = ":main",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Unison runtime and prepare build directory",
        compile_description = "Validate Unison entry with ucm",
        bundle_description = "Verify Unison compile stamp",
        test_description = "Run primary Unison entry",
        test_args = "",
        run_description = "Run Unison application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = ":main",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Unison runtime (debug)",
        compile_description = "Validate Unison entry with ucm (debug)",
        bundle_description = "Verify Unison debug compile stamp",
        test_description = "Run primary Unison entry (verbose)",
        test_args = "",
        run_description = "Run Unison application (debug)",
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
