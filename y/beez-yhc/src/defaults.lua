local M = {}

M.runnable = true

M.build_dir = "build/yhc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.yhc_binary = "yhc"
M.lhc_binary = "lhc"
M.default_compiler = "yhc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[yhc-setup]"
M.log_prefix_compile = "[yhc-compile]"
M.log_prefix_bundle = "[yhc-bundle]"
M.log_prefix_test = "[yhc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.cabal",
    "cabal.project",
    "cabal.project.local",
    "**/*.hs",
}

M.build_profiles = {
    code = {
        scope = "yhc",
        build_mode = "release",
        compiler_flags = "-O2",
        setup_description = "Verify YHC/LHC toolchain and prepare build directories",
        compile_description = "Build Haskell with YHC/LHC (release)",
        bundle_description = "Verify YHC/LHC build artifacts",
        test_description = "Run Haskell tests with YHC/LHC",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "yhc",
        build_mode = "debug",
        compiler_flags = "-O0",
        setup_description = "Verify YHC/LHC toolchain (debug profile)",
        compile_description = "Build Haskell with YHC/LHC (debug, no optimizations)",
        bundle_description = "Verify YHC/LHC debug artifacts",
        test_description = "Run Haskell tests with YHC/LHC (verbose)",
        test_args = "",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "yhc",
        build_mode = "coverage",
        compiler_flags = "",
        setup_description = "Verify YHC/LHC toolchain (coverage profile)",
        compile_description = "Build Haskell with YHC/LHC (coverage instrumentation)",
        bundle_description = "Verify YHC/LHC coverage artifacts",
        test_description = "Run Haskell tests with YHC/LHC coverage profile",
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
