local M = {}

M.runnable = true

M.build_dir = "build/gdc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.gdc_binary = "gdc"
M.dub_binary = "dub"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gdc-setup]"
M.log_prefix_compile = "[gdc-compile]"
M.log_prefix_bundle = "[gdc-bundle]"
M.log_prefix_test = "[gdc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dub.json",
    "dub.sdl",
    "**/*.d",
}

M.build_profiles = {
    code = {
        scope = "gdc",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        debug_symbols = false,
        dub_build = "release",
        gdc_flags = {},
        dub_flags = {},
        setup_description = "Fetch D dependencies (dub)",
        compile_description = "Build with gdc (GNU D Compiler, GCC backend)",
        bundle_description = "Verify gdc build artifacts",
        test_description = "Run D tests with gdc",
        test_args = "",
    },

    debug = {
        scope = "gdc",
        build_mode = "debug",
        output_name = "app",
        optimize = false,
        debug_symbols = true,
        dub_build = "debug",
        gdc_flags = {},
        dub_flags = {},
        setup_description = "Fetch D dependencies (dub debug)",
        compile_description = "Build with gdc (debug, no optimizations)",
        bundle_description = "Verify gdc debug artifacts",
        test_description = "Run D tests with gdc (verbose)",
        test_args = "-v",
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
