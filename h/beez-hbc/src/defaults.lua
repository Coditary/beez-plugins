local M = {}

M.runnable = true

M.build_dir = "build/hbc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.hbc_binary = "hbc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[hbc-setup]"
M.log_prefix_compile = "[hbc-compile]"
M.log_prefix_bundle = "[hbc-bundle]"
M.log_prefix_test = "[hbc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.hs",
}

M.build_profiles = {
    code = {
        scope = "hbc",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        verbose = false,
        setup_description = "Verify HBC/nhc98 toolchain and prepare build directories",
        compile_description = "Compile Haskell-98 sources with HBC/nhc98 (release)",
        bundle_description = "Verify HBC/nhc98 build artifacts",
        test_description = "Compile and run Haskell test programs with HBC/nhc98",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "hbc",
        build_mode = "debug",
        output_name = "app",
        optimize = false,
        verbose = true,
        setup_description = "Verify HBC/nhc98 toolchain (debug profile)",
        compile_description = "Compile Haskell-98 sources with HBC/nhc98 (debug)",
        bundle_description = "Verify HBC/nhc98 debug artifacts",
        test_description = "Run Haskell tests with HBC/nhc98 (debug)",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "hbc",
        build_mode = "coverage",
        output_name = "app",
        optimize = false,
        verbose = true,
        setup_description = "Verify HBC/nhc98 toolchain (coverage profile)",
        compile_description = "Compile Haskell-98 sources with HBC/nhc98 (coverage instrumentation)",
        bundle_description = "Verify HBC/nhc98 coverage artifacts",
        test_description = "Run Haskell tests with HBC/nhc98 coverage profile",
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
