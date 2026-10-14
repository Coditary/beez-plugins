local M = {}

M.runnable = false

M.build_dir = "build/antlr"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.antlr_binary = "antlr4"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[antlr-setup]"
M.log_prefix_compile = "[antlr-compile]"
M.log_prefix_bundle = "[antlr-bundle]"
M.log_prefix_test = "[antlr-test]"


M.common_inputs = {
    "**/*.g4",
    "**/*.g3",
}

M.build_profiles = {
    code = {
        scope = "antlr",
        output_name = "generate.ok",
        language = "C",
        setup_description = "Verify ANTLR parser generator",
        compile_description = "Generate parser from ANTLR grammar (*.g4/*.g3)",
        bundle_description = "Verify ANTLR-generated parser artifacts",
        test_description = "Validate ANTLR grammar generation",
        compile_args = "-no-listener -no-visitor",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "generate.ok",
        language = "C",
        setup_description = "Verify ANTLR parser generator (debug)",
        compile_description = "Generate parser with ANTLR debug output",
        bundle_description = "Verify ANTLR debug parser artifacts",
        test_description = "Validate ANTLR grammar generation (verbose)",
        compile_args = "-no-listener -no-visitor -Xlog",
        test_args = "-Xlog",
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
