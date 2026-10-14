local M = {}

M.runnable = true

M.build_dir = "build/ifx"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ifx_binary = "ifx"
M.ifort_binary = "ifort"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ifx-setup]"
M.log_prefix_compile = "[ifx-compile]"
M.log_prefix_bundle = "[ifx-bundle]"
M.log_prefix_test = "[ifx-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "CMakeLists.txt",
    "**/CMakeLists.txt",
    "Makefile",
    "**/Makefile",
    "**/*.f",
    "**/*.f90",
    "**/*.f95",
}

M.build_profiles = {
    code = {
        scope = "ifx",
        build_mode = "release",
        output_name = "app",
        optimize = "-O3",
        debug_flags = "",
        setup_description = "Verify Intel Fortran compiler and prepare build directories",
        compile_description = "Compile Fortran sources with ifx (-O3)",
        bundle_description = "Verify ifx build artifacts",
        test_description = "Run Fortran tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "ifx",
        build_mode = "debug",
        output_name = "app",
        optimize = "-O0",
        debug_flags = "-g -traceback",
        setup_description = "Verify Intel Fortran compiler (debug)",
        compile_description = "Compile Fortran sources with ifx (debug, no optimizations)",
        bundle_description = "Verify ifx debug artifacts",
        test_description = "Run Fortran tests (debug build)",
        test_args = "",
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
