local M = {}

M.runnable = true

M.build_dir = "build/lfortran"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.lfortran_binary = "lfortran"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[lfortran-setup]"
M.log_prefix_compile = "[lfortran-compile]"
M.log_prefix_bundle = "[lfortran-bundle]"
M.log_prefix_test = "[lfortran-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.f",
    "**/*.f90",
    "**/*.f95",
}

M.build_profiles = {
    code = {
        scope = "lfortran",
        build_mode = "release",
        output_name = "app",
        backend = "llvm",
        lfortran_flags = "--fast",
        setup_description = "Verify LFortran compiler (LLVM backend)",
        compile_description = "Build with LFortran (LLVM, optimized)",
        bundle_description = "Verify LFortran build artifacts",
        test_description = "Run Fortran tests with LFortran",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "lfortran",
        build_mode = "debug",
        output_name = "app",
        backend = "llvm",
        lfortran_flags = "-g",
        setup_description = "Verify LFortran compiler (debug)",
        compile_description = "Build with LFortran (LLVM, debug symbols)",
        bundle_description = "Verify LFortran debug artifacts",
        test_description = "Run Fortran tests with LFortran (debug)",
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
