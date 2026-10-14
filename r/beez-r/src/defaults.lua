local M = {}

M.runnable = true

M.build_dir = "build/r"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.r_binary = "R"
M.rscript_binary = "Rscript"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[r-setup]"
M.log_prefix_compile = "[r-compile]"
M.log_prefix_bundle = "[r-bundle]"
M.log_prefix_test = "[r-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "DESCRIPTION",
    "**/DESCRIPTION",
    "**/*.R",
}

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        setup_description = "Install R package dependencies with R CMD INSTALL deps",
        compile_description = "Build R source package with R CMD build",
        bundle_description = "Verify R package tarball artifacts",
        test_description = "Run R package checks with R CMD check",
        check_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Install R package dependencies with R CMD INSTALL deps (debug)",
        compile_description = "Build R source package with R CMD build (debug)",
        bundle_description = "Verify R debug package tarball artifacts",
        test_description = "Run R package checks with R CMD check (verbose)",
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
