local M = {}

M.runnable = false

M.build_dir = "build/pegjs"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.peggy_binary = "peggy"
M.pegjs_binary = "pegjs"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pegjs-setup]"
M.log_prefix_compile = "[pegjs-compile]"
M.log_prefix_bundle = "[pegjs-bundle]"
M.log_prefix_test = "[pegjs-test]"


M.common_inputs = {
    "**/*.pegjs",
    "**/*.peggy",
}

M.build_profiles = {
    code = {
        scope = "pegjs",
        output_name = "parser.js",
        setup_description = "Verify Peggy/PEG.js parser generator",
        compile_description = "Generate JavaScript parser from PEG grammar",
        bundle_description = "Verify Peggy-generated parser artifacts",
        test_description = "Validate PEG grammar with parser generation",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "parser.js",
        setup_description = "Verify Peggy/PEG.js parser generator (debug)",
        compile_description = "Generate JavaScript parser with source maps",
        bundle_description = "Verify Peggy debug parser artifacts",
        test_description = "Validate PEG grammar (verbose generation)",
        compile_args = "--source-map",
        test_args = "",
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
