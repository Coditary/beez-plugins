local M = {}

M.runnable = true

M.build_dir = "build/gpc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.gpc_binary = "gpc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gpc-setup]"
M.log_prefix_compile = "[gpc-compile]"
M.log_prefix_bundle = "[gpc-bundle]"
M.log_prefix_test = "[gpc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.pas",
    "**/*.p",
}

M.build_profiles = {
    code = {
        scope = "gpc",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        debug_info = false,
        setup_description = "Verify GPC toolchain and prepare build directories",
        compile_description = "Compile Pascal sources with GPC (release)",
        bundle_description = "Verify GPC build artifacts",
        test_description = "Compile and run Pascal test programs with GPC",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "gpc",
        build_mode = "debug",
        output_name = "app",
        optimize = false,
        debug_info = true,
        setup_description = "Verify GPC toolchain (debug profile)",
        compile_description = "Compile Pascal sources with GPC (debug)",
        bundle_description = "Verify GPC debug artifacts",
        test_description = "Run Pascal tests with GPC (debug)",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "gpc",
        build_mode = "coverage",
        output_name = "app",
        optimize = false,
        debug_info = true,
        setup_description = "Verify GPC toolchain (coverage profile)",
        compile_description = "Compile Pascal sources with GPC (coverage instrumentation)",
        bundle_description = "Verify GPC coverage artifacts",
        test_description = "Run Pascal tests with GPC coverage profile",
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
