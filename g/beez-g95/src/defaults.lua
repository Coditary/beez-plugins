local M = {}

M.runnable = true

M.build_dir = "build/g95"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.g95_binary = "g95"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[g95-setup]"
M.log_prefix_compile = "[g95-compile]"
M.log_prefix_bundle = "[g95-bundle]"
M.log_prefix_test = "[g95-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.f",
    "**/*.f90",
    "**/*.f95",
}

M.build_profiles = {
    code = {
        scope = "g95",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        debug_info = false,
        setup_description = "Verify G95 toolchain and prepare build directories",
        compile_description = "Compile Fortran sources with G95 (release)",
        bundle_description = "Verify G95 build artifacts",
        test_description = "Compile and run Fortran test programs with G95",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "g95",
        build_mode = "debug",
        output_name = "app",
        optimize = false,
        debug_info = true,
        setup_description = "Verify G95 toolchain (debug profile)",
        compile_description = "Compile Fortran sources with G95 (debug)",
        bundle_description = "Verify G95 debug artifacts",
        test_description = "Run Fortran tests with G95 (debug)",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "g95",
        build_mode = "coverage",
        output_name = "app",
        optimize = false,
        debug_info = true,
        setup_description = "Verify G95 toolchain (coverage profile)",
        compile_description = "Compile Fortran sources with G95 (coverage instrumentation)",
        bundle_description = "Verify G95 coverage artifacts",
        test_description = "Run Fortran tests with G95 coverage profile",
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
