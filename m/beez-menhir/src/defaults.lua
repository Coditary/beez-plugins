local M = {}

M.runnable = false

M.build_dir = "build/menhir"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.menhir_binary = "menhir"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[menhir-setup]"
M.log_prefix_compile = "[menhir-compile]"
M.log_prefix_bundle = "[menhir-bundle]"
M.log_prefix_test = "[menhir-test]"


M.common_inputs = {
    "**/*.mly",
}

M.build_profiles = {
    code = {
        scope = "menhir",
        base_name = "parser",
        output_name = "parser.ml",
        interface_name = "parser.mli",
        setup_description = "Verify Menhir OCaml parser generator",
        compile_description = "Generate OCaml parser from Menhir *.mly grammar",
        bundle_description = "Verify Menhir-generated parser artifacts",
        test_description = "Validate Menhir grammar with report",
        compile_args = "",
        test_args = "--only-check",
    },

    debug = {
        scope = "debug",
        base_name = "parser",
        output_name = "parser.ml",
        interface_name = "parser.mli",
        setup_description = "Verify Menhir parser generator (debug)",
        compile_description = "Generate OCaml parser with Menhir verbose output",
        bundle_description = "Verify Menhir debug parser artifacts",
        test_description = "Validate Menhir grammar (verbose check)",
        compile_args = "--verbose",
        test_args = "--only-check --verbose",
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
