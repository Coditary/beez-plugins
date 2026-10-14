local M = {}

M.runnable = true

M.build_dir = "build/tsc"
M.dist_dir = M.build_dir .. "/dist"
M.reports_dir = "report"

M.tsc_binary = "npx tsc"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tsc-setup]"
M.log_prefix_compile = "[tsc-compile]"
M.log_prefix_bundle = "[tsc-bundle]"
M.log_prefix_test = "[tsc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "tsconfig.json",
    "**/tsconfig.json",
    "package.json",
    "**/package.json",
    "**/*.ts",
    "**/*.tsx",
}

M.build_profiles = {
    code = {
        scope = "app",
        build_mode = "release",
        setup_description = "Install TypeScript dependencies with npm",
        compile_description = "Compile TypeScript with tsc (release)",
        bundle_description = "Verify TypeScript build artifacts",
        test_description = "Run TypeScript project tests",
        tsc_args = "",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        setup_description = "Install TypeScript dependencies with npm (debug)",
        compile_description = "Compile TypeScript with tsc (debug)",
        bundle_description = "Verify TypeScript debug artifacts",
        test_description = "Run TypeScript project tests (verbose)",
        tsc_args = "--sourceMap",
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
