local M = {}

M.runnable = false

M.build_dir = "build/style-dictionary"
M.dist_dir = M.build_dir
M.reports_dir = "report"

M.style_dictionary_binary = "style-dictionary"
M.npm_binary = "npm"
M.npx_binary = "npx"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[style-dictionary-setup]"
M.log_prefix_compile = "[style-dictionary-compile]"
M.log_prefix_bundle = "[style-dictionary-bundle]"
M.log_prefix_test = "[style-dictionary-test]"


M.common_inputs = {
    "config.json",
    "**/config.json",
    "style-dictionary.config.js",
    "**/style-dictionary.config.js",
    "style-dictionary.config.json",
    "**/style-dictionary.config.json",
    "**/tokens/**/*.json",
    "package.json",
    "**/package.json",
}

M.build_profiles = {
    code = {
        scope = "style-dictionary",
        output_name = "tokens",
        setup_description = "Install Style Dictionary design token dependencies",
        compile_description = "Build design tokens with style-dictionary",
        bundle_description = "Verify Style Dictionary build artifacts",
        test_description = "Validate Style Dictionary token build",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "tokens",
        setup_description = "Install Style Dictionary dependencies (debug)",
        compile_description = "Build design tokens with style-dictionary (verbose)",
        bundle_description = "Verify Style Dictionary debug artifacts",
        test_description = "Validate Style Dictionary token build (verbose)",
        test_args = "--verbose",
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


return M
