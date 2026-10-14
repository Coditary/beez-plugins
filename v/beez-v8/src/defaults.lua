local M = {}

M.runnable = true

M.build_dir = "build/v8"
M.dist_dir = M.build_dir .. "/dist"
M.reports_dir = "report"

M.node_binary = "node"
M.d8_binary = "d8"
M.npm_binary = "npm"
M.v8_engine = "node"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[v8-setup]"
M.log_prefix_compile = "[v8-compile]"
M.log_prefix_bundle = "[v8-bundle]"
M.log_prefix_test = "[v8-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "package.json",
    "**/package.json",
    "**/*.js",
    "**/*.mjs",
}

M.build_profiles = {
    code = {
        scope = "v8",
        build_mode = "release",
        setup_description = "Install JavaScript dependencies and verify V8 runtime",
        compile_description = "Validate JavaScript with node --check (V8 parser)",
        bundle_description = "Verify V8 build artifacts under build/v8/",
        test_description = "Run JavaScript project tests",
        compile_args = "",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "v8",
        build_mode = "debug",
        setup_description = "Install JavaScript dependencies and verify V8 runtime (debug)",
        compile_description = "Validate JavaScript with d8 (V8 shell)",
        bundle_description = "Verify V8 debug build artifacts",
        test_description = "Run JavaScript project tests (verbose)",
        v8_engine = "d8",
        compile_args = "",
        test_args = "--verbose",
        run_description = "Run application (debug)",
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
