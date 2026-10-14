local M = {}

M.runnable = true

M.build_dir = "build/perl-bc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.perl_binary = "perl"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[perl-bc-setup]"
M.log_prefix_compile = "[perl-bc-compile]"
M.log_prefix_bundle = "[perl-bc-bundle]"
M.log_prefix_test = "[perl-bc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Makefile.PL",
    "**/Makefile.PL",
    "**/*.pl",
}

M.build_profiles = {
    code = {
        scope = "perl-bc",
        output_name = "app",
        setup_description = "Verify perl and B::C backend availability",
        compile_description = "Compile Perl sources to C with perl -MO=C,-o",
        bundle_description = "Verify B::C generated C artifacts",
        test_description = "Run Perl tests with prove or make test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "perl-bc",
        output_name = "app",
        setup_description = "Verify perl and B::C backend availability (debug)",
        compile_description = "Compile Perl sources to C with perl -MO=C,-o (debug)",
        bundle_description = "Verify B::C debug generated C artifacts",
        test_description = "Run Perl tests with prove or make test (verbose)",
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
