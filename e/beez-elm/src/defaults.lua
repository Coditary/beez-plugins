local M = {}

M.runnable = true

M.build_dir = "build/elm"
M.output_dir = M.build_dir
M.reports_dir = "report"

M.elm_binary = "elm"
M.elm_test_binary = "elm-test"
M.elm_test_rs_binary = "elm-test-rs"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[elm-setup]"
M.log_prefix_compile = "[elm-compile]"
M.log_prefix_bundle = "[elm-bundle]"
M.log_prefix_test = "[elm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "elm.json",
    "**/elm.json",
    "**/*.elm",
}

M.build_profiles = {
    code = {
        scope = "app",
        optimize = true,
        output_name = "app.js",
        setup_description = "Verify elm and install dependencies",
        compile_description = "Compile Elm to JavaScript",
        bundle_description = "Verify Elm build artifacts",
        test_description = "Run Elm tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        optimize = false,
        output_name = "app.js",
        setup_description = "Verify elm and install dependencies (debug)",
        compile_description = "Compile Elm to JavaScript (debug)",
        bundle_description = "Verify Elm debug artifacts",
        test_description = "Run Elm tests (verbose)",
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
