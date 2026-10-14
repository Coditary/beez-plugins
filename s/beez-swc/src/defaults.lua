local M = {}

M.runnable = true

M.build_dir = "build/swc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.swc_binary = "swc"
M.npx_swc_cli = "npx @swc/cli"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[swc-setup]"
M.log_prefix_compile = "[swc-compile]"
M.log_prefix_bundle = "[swc-bundle]"
M.log_prefix_test = "[swc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    ".swcrc",
    "**/.swcrc",
    "package.json",
    "**/package.json",
    "**/*.ts",
    "**/*.tsx",
}

M.build_profiles = {
    code = {
        scope = "swc",
        build_mode = "release",
        source_maps = false,
        setup_description = "Install npm dependencies for SWC",
        compile_description = "Transpile TypeScript/JavaScript with SWC (release)",
        bundle_description = "Verify SWC build artifacts",
        test_description = "Run npm tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        source_maps = true,
        setup_description = "Install npm dependencies for SWC (debug)",
        compile_description = "Transpile TypeScript/JavaScript with SWC (debug, source maps)",
        bundle_description = "Verify SWC debug artifacts",
        test_description = "Run npm tests (verbose)",
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
