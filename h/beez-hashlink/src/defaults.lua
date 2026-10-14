local M = {}

M.runnable = true

M.build_dir = "build/hashlink"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.hashlink_binary = "hl"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[hashlink-setup]"
M.log_prefix_compile = "[hashlink-compile]"
M.log_prefix_bundle = "[hashlink-bundle]"
M.log_prefix_test = "[hashlink-test]"
M.log_prefix_run = "[hashlink-run]"

M.common_inputs = {
    "**/*.hl"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Hashlink runtime and prepare build directory",
        compile_description = "Validate Hashlink entry with hl",
        bundle_description = "Verify Hashlink compile stamp",
        test_description = "Run primary Hashlink entry",
        test_args = "",
        run_description = "Run Hashlink application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Hashlink runtime (debug)",
        compile_description = "Validate Hashlink entry with hl (debug)",
        bundle_description = "Verify Hashlink debug compile stamp",
        test_description = "Run primary Hashlink entry (verbose)",
        test_args = "",
        run_description = "Run Hashlink application (debug)",
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
