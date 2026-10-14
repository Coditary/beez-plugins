local M = {}

M.runnable = true

M.build_dir = "build/rakudo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.raku_binary = "raku"
M.rakudo_moar_binary = "rakudo-moar"
M.zef_binary = "zef"
M.prove6_binary = "prove6"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[rakudo-setup]"
M.log_prefix_compile = "[rakudo-compile]"
M.log_prefix_bundle = "[rakudo-bundle]"
M.log_prefix_test = "[rakudo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "META6.json",
    "**/META6.json",
    "**/*.raku",
    "**/*.rakumod",
    "**/*.pm6",
}

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        compile_mode = "syntax",
        setup_description = "Install Raku dependencies with zef (META6.json)",
        compile_description = "Syntax-check Raku sources (raku -c)",
        bundle_description = "Verify Raku compile artifacts",
        test_description = "Run Raku tests with prove6 or raku (t/)",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_mode = "moar",
        setup_description = "Install Raku dependencies with zef (debug)",
        compile_description = "Compile Raku sources via rakudo-moar (-c)",
        bundle_description = "Verify Raku debug compile artifacts",
        test_description = "Run Raku tests with prove6 (verbose)",
        test_args = "-v",
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
