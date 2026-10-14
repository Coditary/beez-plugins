local M = {}

M.runnable = true

M.build_dir = "build/esbuild"
M.dist_dir = M.build_dir
M.reports_dir = "report"

M.esbuild_binary = "esbuild"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[esbuild-setup]"
M.log_prefix_compile = "[esbuild-compile]"
M.log_prefix_bundle = "[esbuild-bundle]"
M.log_prefix_test = "[esbuild-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "package.json",
    "**/package.json",
    "**/*.ts",
    "**/*.tsx",
    "**/*.js",
}

M.build_profiles = {
    code = {
        scope = "esbuild",
        build_mode = "release",
        output_name = "app",
        setup_description = "Install JavaScript/TypeScript dependencies with npm",
        compile_description = "Bundle and minify with esbuild (release)",
        bundle_description = "Verify esbuild bundle artifacts",
        test_description = "Run project tests with npm",
        esbuild_args = "--bundle --minify",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "esbuild",
        build_mode = "debug",
        output_name = "app",
        setup_description = "Install JavaScript/TypeScript dependencies with npm (debug)",
        compile_description = "Bundle with esbuild (debug, source maps)",
        bundle_description = "Verify esbuild debug bundle artifacts",
        test_description = "Run project tests with npm (verbose)",
        esbuild_args = "--bundle --sourcemap",
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
