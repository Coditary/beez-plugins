local M = {}

M.runnable = true

M.build_dir = "build/perl"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.perl_binary = "perl"
M.cpanm_binary = "cpanm"
M.cpan_binary = "cpan"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[perl-setup]"
M.log_prefix_compile = "[perl-compile]"
M.log_prefix_bundle = "[perl-bundle]"
M.log_prefix_test = "[perl-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "cpanfile",
    "**/cpanfile",
    "Makefile.PL",
    "**/Makefile.PL",
    "**/*.pl",
    "**/*.pm",
}

M.compile_exclude = [[/(\.git|build|blib|\.venv|local|inc)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        setup_description = "Install Perl dependencies with cpanm/cpan or run Makefile.PL",
        compile_description = "Syntax-check Perl sources with perl -c",
        bundle_description = "Verify Perl compile stamp",
        test_description = "Run Perl tests with prove or make test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Install Perl dependencies with cpanm/cpan or run Makefile.PL (debug)",
        compile_description = "Syntax-check Perl sources with perl -c (debug)",
        bundle_description = "Verify Perl debug compile stamp",
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
