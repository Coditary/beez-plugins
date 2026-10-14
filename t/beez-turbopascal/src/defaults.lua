local M = {}

M.runnable = true

M.build_dir = "build/turbopascal"
M.bin_dir = M.build_dir .. "/bin"
M.obj_dir = M.build_dir .. "/obj"
M.reports_dir = "report"

M.tpc_binary = "tpc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[turbopascal-setup]"
M.log_prefix_compile = "[turbopascal-compile]"
M.log_prefix_bundle = "[turbopascal-bundle]"
M.log_prefix_test = "[turbopascal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.pas",
    "**/*.p",
}

M.build_profiles = {
    code = {
        scope = "turbopascal",
        build_mode = "release",
        output_name = "app",
        tpc_args = "/m",
        setup_description = "Verify Turbo Pascal toolchain and prepare build directories",
        compile_description = "Compile Pascal sources with Turbo Pascal (release)",
        bundle_description = "Verify Turbo Pascal build artifacts",
        test_description = "Compile and run Pascal test programs with Turbo Pascal",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "turbopascal",
        build_mode = "debug",
        output_name = "app",
        tpc_args = "/m /V",
        setup_description = "Verify Turbo Pascal toolchain (debug profile)",
        compile_description = "Compile Pascal sources with Turbo Pascal (debug)",
        bundle_description = "Verify Turbo Pascal debug artifacts",
        test_description = "Run Pascal tests with Turbo Pascal (debug)",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "turbopascal",
        build_mode = "coverage",
        output_name = "app",
        tpc_args = "/m /V",
        setup_description = "Verify Turbo Pascal toolchain (coverage profile)",
        compile_description = "Compile Pascal sources with Turbo Pascal (coverage instrumentation)",
        bundle_description = "Verify Turbo Pascal coverage artifacts",
        test_description = "Run Pascal tests with Turbo Pascal coverage profile",
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
