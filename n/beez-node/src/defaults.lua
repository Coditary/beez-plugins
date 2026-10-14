local M = {}

M.runnable = true

M.build_dir = "build/node"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.node_binary = "node"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[node-setup]"
M.log_prefix_compile = "[node-compile]"
M.log_prefix_bundle = "[node-bundle]"
M.log_prefix_test = "[node-test]"
M.log_prefix_run = "[node-run]"

M.common_inputs = {
    "**/*.js",
    "**/*.mjs",
    "**/*.cjs",
    "package.json",
    "**/package.json"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Node runtime and prepare build directory",
        compile_description = "Validate Node entry with node",
        bundle_description = "Verify Node compile stamp",
        test_description = "Run primary Node entry",
        test_args = "",
        run_description = "Run Node application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Node runtime (debug)",
        compile_description = "Validate Node entry with node (debug)",
        bundle_description = "Verify Node debug compile stamp",
        test_description = "Run primary Node entry (verbose)",
        test_args = "",
        run_description = "Run Node application (debug)",
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
