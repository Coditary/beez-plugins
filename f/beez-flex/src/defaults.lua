local M = {}

M.runnable = false

M.build_dir = "build/flex"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.flex_binary = "flex"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[flex-setup]"
M.log_prefix_compile = "[flex-compile]"
M.log_prefix_bundle = "[flex-bundle]"
M.log_prefix_test = "[flex-test]"


M.common_inputs = {
    "**/*.l",
    "**/*.lex",
}

M.build_profiles = {
    code = {
        scope = "flex",
        output_name = "lex.yy.c",
        setup_description = "Verify GNU Flex lexer generator",
        compile_description = "Generate C lexer from Flex *.l/*.lex sources",
        bundle_description = "Verify Flex-generated lexer artifacts",
        test_description = "Validate Flex lexer specification",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "lex.yy.c",
        setup_description = "Verify GNU Flex lexer generator (debug)",
        compile_description = "Generate C lexer with Flex debug output",
        bundle_description = "Verify Flex debug lexer artifacts",
        test_description = "Validate Flex lexer specification (verbose)",
        compile_args = "--debug",
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
