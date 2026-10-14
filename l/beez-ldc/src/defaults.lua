local M = {}

M.runnable = true

M.build_dir = "build/ldc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ldc_binary = "ldc2"
M.dub_binary = "dub"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ldc-setup]"
M.log_prefix_compile = "[ldc-compile]"
M.log_prefix_bundle = "[ldc-bundle]"
M.log_prefix_test = "[ldc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dub.json",
    "dub.sdl",
    "**/dub.json",
    "**/dub.sdl",
    "**/*.d",
}

M.build_profiles = {
    code = {
        scope = "ldc",
        build_mode = "release",
        output_name = "app",
        ldc_flags = "-O3 -release",
        dub_build = "release",
        dub_dflags = "-O3 -release",
        setup_description = "Fetch D package dependencies (dub + LDC)",
        compile_description = "Build with LDC (ldc2, -O3 release)",
        bundle_description = "Verify LDC build artifacts",
        test_description = "Run D tests with dub and LDC",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        ldc_flags = "-g -d-debug",
        dub_build = "debug",
        dub_dflags = "-g",
        setup_description = "Fetch D package dependencies (dub + LDC debug)",
        compile_description = "Build with LDC (ldc2, debug -g)",
        bundle_description = "Verify LDC debug build artifacts",
        test_description = "Run D tests with dub and LDC (verbose)",
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
