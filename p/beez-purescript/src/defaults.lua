local M = {}

M.runnable = true

M.build_dir = "build/purescript"
M.output_dir = M.build_dir .. "/output"
M.reports_dir = "report"

M.spago_binary = "spago"
M.purs_binary = "purs"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[purescript-setup]"
M.log_prefix_compile = "[purescript-compile]"
M.log_prefix_bundle = "[purescript-bundle]"
M.log_prefix_test = "[purescript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "spago.yaml",
    "spago.dhall",
    "**/spago.yaml",
    "**/spago.dhall",
    "package.json",
    "**/package.json",
    "**/*.purs",
}

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app.js",
        setup_description = "Install PureScript dependencies with spago or npm",
        compile_description = "Compile PureScript (spago build or purs compile)",
        bundle_description = "Verify PureScript build artifacts",
        test_description = "Run PureScript tests with spago test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.js",
        setup_description = "Install PureScript dependencies (debug)",
        compile_description = "Compile PureScript (debug)",
        bundle_description = "Verify PureScript debug artifacts",
        test_description = "Run PureScript tests (verbose)",
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
