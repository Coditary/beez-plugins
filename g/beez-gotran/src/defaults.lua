local M = {}

M.runnable = true

M.build_dir = "build/gotran"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.gotran_binary = "gotran"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gotran-setup]"
M.log_prefix_compile = "[gotran-compile]"
M.log_prefix_bundle = "[gotran-bundle]"
M.log_prefix_test = "[gotran-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.for",
    "**/*.got",
}

M.build_profiles = {
    code = {
        scope = "gotran",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify GOTRAN Fortran dialect compiler and prepare build directory",
        compile_description = "Compile GOTRAN Fortran sources (*.for, *.got)",
        bundle_description = "Verify GOTRAN build artifacts",
        test_description = "Verify GOTRAN build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "gotran",
        output_name = "app",
        compile_flag = "-g",
        setup_description = "Verify GOTRAN compiler and prepare build directory (debug)",
        compile_description = "Compile GOTRAN Fortran sources with debug symbols",
        bundle_description = "Verify GOTRAN debug build artifacts",
        test_description = "Verify GOTRAN debug build output",
        test_args = "-v",
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
