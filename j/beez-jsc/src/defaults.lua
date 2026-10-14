local M = {}

M.runnable = true

M.build_dir = "build/jsc"
M.dist_dir = M.build_dir .. "/dist"
M.reports_dir = "report"

M.jsc_binary = "jsc"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jsc-setup]"
M.log_prefix_compile = "[jsc-compile]"
M.log_prefix_bundle = "[jsc-bundle]"
M.log_prefix_test = "[jsc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "package.json",
    "**/package.json",
    "**/*.js",
}

M.build_profiles = {
    code = {
        scope = "jsc",
        build_mode = "release",
        setup_description = "Verify JavaScriptCore (jsc) and install npm dependencies",
        compile_description = "Compile JavaScript to bytecode with jsc -b (release)",
        bundle_description = "Verify JavaScriptCore bytecode artifacts",
        test_description = "Run JavaScript project tests",
        jsc_args = "",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jsc",
        build_mode = "debug",
        setup_description = "Verify JavaScriptCore (jsc) and install npm dependencies (debug)",
        compile_description = "Compile JavaScript to bytecode with jsc -b (debug)",
        bundle_description = "Verify JavaScriptCore debug bytecode artifacts",
        test_description = "Run JavaScript project tests (verbose)",
        jsc_args = "",
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
