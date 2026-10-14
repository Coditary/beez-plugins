local M = {}

M.runnable = true

M.build_dir = "build/bucklescript"
M.js_dir = M.build_dir .. "/js"
M.bs_dir = M.build_dir .. "/bs"
M.reports_dir = "report"

M.bsb_binary = "npx bsb"
M.bsb_native_binary = "npx bsb-native"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bucklescript-setup]"
M.log_prefix_compile = "[bucklescript-compile]"
M.log_prefix_bundle = "[bucklescript-bundle]"
M.log_prefix_test = "[bucklescript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "bsconfig.json",
    "**/bsconfig.json",
    "package.json",
    "**/package.json",
    "**/*.ml",
    "**/*.mli",
    "**/*.re",
    "**/*.rei",
}

M.build_profiles = {
    code = {
        scope = "bucklescript",
        build_mode = "release",
        use_native = false,
        setup_description = "Install BuckleScript dependencies with npm",
        compile_description = "Compile BuckleScript project with bsb -make-world",
        bundle_description = "Verify BuckleScript build artifacts",
        test_description = "Run BuckleScript project tests",
        bsb_args = "-make-world",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "bucklescript",
        build_mode = "debug",
        use_native = false,
        setup_description = "Install BuckleScript dependencies with npm (debug)",
        compile_description = "Compile BuckleScript project with bsb -make-world (verbose)",
        bundle_description = "Verify BuckleScript debug artifacts",
        test_description = "Run BuckleScript project tests (verbose)",
        bsb_args = "-make-world -verbose",
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
