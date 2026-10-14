local M = {}

M.runnable = true

M.build_dir = "build/ghc"
M.bin_dir = M.build_dir .. "/bin"
M.dist_dir = "dist-newstyle"
M.reports_dir = "report"

M.ghc_binary = "ghc"
M.cabal_binary = "cabal"
M.stack_binary = "stack"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ghc-setup]"
M.log_prefix_compile = "[ghc-compile]"
M.log_prefix_bundle = "[ghc-bundle]"
M.log_prefix_test = "[ghc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.cabal",
    "stack.yaml",
    "stack.yaml.lock",
    "cabal.project",
    "cabal.project.local",
    "**/*.hs",
}

M.build_profiles = {
    code = {
        scope = "app",
        build_mode = "release",
        ghc_options = "",
        setup_description = "Update Cabal index or run stack setup (GHC)",
        compile_description = "Build Haskell with GHC (release)",
        bundle_description = "Verify GHC build artifacts",
        test_description = "Run Haskell tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        ghc_options = "-O0 -g",
        setup_description = "Update Cabal index or run stack setup (GHC debug)",
        compile_description = "Build Haskell with GHC (debug, no optimizations)",
        bundle_description = "Verify GHC debug artifacts",
        test_description = "Run Haskell tests (verbose)",
        test_args = "--test-show-details=direct",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "coverage",
        build_mode = "coverage",
        ghc_options = "-fhpc",
        setup_description = "Update Cabal index or run stack setup (GHC coverage)",
        compile_description = "Build Haskell with GHC (HPC coverage instrumentation)",
        bundle_description = "Verify GHC coverage artifacts",
        test_description = "Run Haskell tests with HPC coverage",
        test_args = "",
        run_description = "Run application (coverage)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
    ["configure:coverage"] = "coverage",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
    ["compile:coverage"] = "coverage",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
    ["bundle:coverage"] = "coverage",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
    ["test:coverage"] = "coverage",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:coverage"] = "coverage",
    ["run:debug"] = "debug",
}

return M
