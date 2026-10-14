local M = {}

M.runnable = true

M.build_dir = "build/sucrase"
M.dist_dir = M.build_dir
M.reports_dir = "report"

M.sucrase_binary = "npx sucrase"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sucrase-setup]"
M.log_prefix_compile = "[sucrase-compile]"
M.log_prefix_bundle = "[sucrase-bundle]"
M.log_prefix_test = "[sucrase-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "package.json",
    "**/package.json",
    "**/*.ts",
    "**/*.tsx",
}

M.build_profiles = {
    code = {
        scope = "sucrase",
        build_mode = "release",
        setup_description = "Install TypeScript/JavaScript dependencies with npm",
        compile_description = "Transpile TypeScript with Sucrase (release, no typecheck)",
        bundle_description = "Verify Sucrase build artifacts",
        test_description = "Run TypeScript/JavaScript project tests",
        sucrase_transforms = "typescript,jsx,imports",
        sucrase_args = "",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "sucrase",
        build_mode = "debug",
        setup_description = "Install TypeScript/JavaScript dependencies with npm (debug)",
        compile_description = "Transpile TypeScript with Sucrase (debug, source maps)",
        bundle_description = "Verify Sucrase debug artifacts",
        test_description = "Run TypeScript/JavaScript project tests (verbose)",
        sucrase_transforms = "typescript,jsx,imports",
        sucrase_args = "--source-maps",
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
