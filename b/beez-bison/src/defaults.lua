local M = {}

M.runnable = false

M.build_dir = "build/bison"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.bison_binary = "bison"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bison-setup]"
M.log_prefix_compile = "[bison-compile]"
M.log_prefix_bundle = "[bison-bundle]"
M.log_prefix_test = "[bison-test]"


M.common_inputs = {
    "**/*.y",
    "**/*.yy",
    "**/*.yacc",
}

M.build_profiles = {
    code = {
        scope = "bison",
        output_name = "parser.tab.c",
        header_name = "parser.tab.h",
        setup_description = "Verify GNU Bison parser generator",
        compile_description = "Generate C parser from Yacc/Bison grammar",
        bundle_description = "Verify Bison-generated parser artifacts",
        test_description = "Validate Yacc/Bison grammar with report",
        compile_args = "",
        test_args = "--report=all",
    },

    debug = {
        scope = "debug",
        output_name = "parser.tab.c",
        header_name = "parser.tab.h",
        setup_description = "Verify GNU Bison parser generator (debug)",
        compile_description = "Generate C parser with verbose Bison output",
        bundle_description = "Verify Bison debug parser artifacts",
        test_description = "Validate Yacc/Bison grammar (verbose report)",
        compile_args = "--verbose",
        test_args = "--report=all --verbose",
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
