local M = {}

M.runnable = true

M.build_dir = "build/cxxr"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.cxxr_binary = "cxxr"
M.r_fallback_binary = "R"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cxxr-setup]"
M.log_prefix_compile = "[cxxr-compile]"
M.log_prefix_bundle = "[cxxr-bundle]"
M.log_prefix_test = "[cxxr-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "DESCRIPTION",
    "**/DESCRIPTION",
    "**/*.R",
}

M.build_profiles = {
    code = {
        scope = "cxxr",
        output_name = "app",
        setup_description = "Install R package dependencies with CXXR/R CMD INSTALL deps",
        compile_description = "Build R source package with CXXR/R CMD build",
        bundle_description = "Verify CXXR R package tarball artifacts",
        test_description = "Run R package checks with CXXR/R CMD check",
        check_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "cxxr",
        output_name = "app",
        setup_description = "Install R package dependencies with CXXR/R CMD INSTALL deps (debug)",
        compile_description = "Build R source package with CXXR/R CMD build (debug)",
        bundle_description = "Verify CXXR debug package tarball artifacts",
        test_description = "Run R package checks with CXXR/R CMD check (verbose)",
        check_args = "--verbose",
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
