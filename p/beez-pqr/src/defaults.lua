local M = {}

M.runnable = true

M.build_dir = "build/pqr"
M.bin_dir = M.build_dir
M.lib_dir = M.build_dir .. "/lib"
M.reports_dir = "report"

M.pqr_binary = "pqR"
M.pqr_fallback_binary = "R"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pqr-setup]"
M.log_prefix_compile = "[pqr-compile]"
M.log_prefix_bundle = "[pqr-bundle]"
M.log_prefix_test = "[pqr-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "DESCRIPTION",
    "**/DESCRIPTION",
    "**/*.R",
}

M.cran_repos = "https://cloud.r-project.org"

M.build_profiles = {
    code = {
        scope = "pqr",
        output_name = "app",
        setup_description = "Install R package dependencies with pqR/R (remotes::install_deps)",
        compile_description = "Build R package or byte-compile scripts with pqR/R CMD INSTALL",
        bundle_description = "Verify pqR build artifacts under build/pqr/",
        test_description = "Run R tests with testthat via pqR/R",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "pqr",
        output_name = "app",
        setup_description = "Install R package dependencies with pqR/R (debug)",
        compile_description = "Build R package or byte-compile scripts with pqR/R (debug)",
        bundle_description = "Verify pqR debug build artifacts",
        test_description = "Run R tests with testthat via pqR/R (verbose)",
        test_args = "--verbose",
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
