local M = {}

M.runnable = false

M.build_dir = "build/tree-sitter"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.tree_sitter_binary = "tree-sitter"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tree-sitter-setup]"
M.log_prefix_compile = "[tree-sitter-compile]"
M.log_prefix_bundle = "[tree-sitter-bundle]"
M.log_prefix_test = "[tree-sitter-test]"


M.common_inputs = {
    "grammar.js",
    "**/grammar.js",
    "bindings/node/binding.gyp",
}

M.build_profiles = {
    code = {
        scope = "tree-sitter",
        output_name = "parser.c",
        setup_description = "Verify Tree-sitter incremental parser CLI",
        compile_description = "Generate Tree-sitter parser from grammar.js",
        bundle_description = "Verify Tree-sitter generated parser artifacts",
        test_description = "Run Tree-sitter grammar tests",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "parser.c",
        setup_description = "Verify Tree-sitter CLI (debug)",
        compile_description = "Generate Tree-sitter parser with debug logging",
        bundle_description = "Verify Tree-sitter debug parser artifacts",
        test_description = "Run Tree-sitter grammar tests (verbose)",
        compile_args = "--log",
        test_args = "--debug",
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
