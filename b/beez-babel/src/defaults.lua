local M = {}

M.runnable = true

M.build_dir = "build/babel"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.babel_binary = "babel"
M.npm_binary = "npm"
M.use_npx = false
M.preset = "@babel/preset-typescript"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[babel-setup]"
M.log_prefix_compile = "[babel-compile]"
M.log_prefix_bundle = "[babel-bundle]"
M.log_prefix_test = "[babel-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "babel.config.js",
    "babel.config.json",
    "babel.config.cjs",
    "babel.config.mjs",
    ".babelrc",
    ".babelrc.json",
    "package.json",
    "**/package.json",
    "**/*.ts",
    "**/*.tsx",
}

M.build_profiles = {
    code = {
        scope = "babel",
        build_mode = "release",
        extensions = ".ts,.tsx",
        presets = { "@babel/preset-typescript" },
        source_maps = false,
        copy_files = true,
        setup_description = "Install npm dependencies (@babel/core, @babel/cli, @babel/preset-typescript)",
        compile_description = "Transpile TypeScript/JavaScript with Babel (@babel/preset-typescript)",
        bundle_description = "Verify Babel build artifacts",
        test_description = "Run npm test",
        test_args = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        extensions = ".ts,.tsx",
        presets = { "@babel/preset-typescript" },
        source_maps = true,
        copy_files = true,
        setup_description = "Install npm dependencies (debug)",
        compile_description = "Transpile TypeScript/JavaScript with Babel (debug, source maps)",
        bundle_description = "Verify Babel debug artifacts",
        test_description = "Run npm test (verbose)",
        test_args = "-- --verbose",
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
