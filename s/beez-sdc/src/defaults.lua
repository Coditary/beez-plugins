local M = {}

M.runnable = true

M.build_dir = "build/sdc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.sdc_binary = "sdc"
M.dub_binary = "dub"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sdc-setup]"
M.log_prefix_compile = "[sdc-compile]"
M.log_prefix_bundle = "[sdc-bundle]"
M.log_prefix_test = "[sdc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dub.json",
    "dub.sdl",
    "**/*.d",
}

M.build_profiles = {
    code = {
        scope = "sdc",
        build_mode = "release",
        dub_build = "release",
        sdc_flags = { "-O", "-release" },
        output_name = "app",
        setup_description = "Fetch Dub dependencies (sdc release)",
        compile_description = "Build D project with sdc (release)",
        bundle_description = "Verify sdc release build artifacts",
        test_description = "Run D tests with sdc",
        test_args = "",
    },

    debug = {
        scope = "sdc",
        build_mode = "debug",
        dub_build = "debug",
        sdc_flags = { "-g", "-debug" },
        output_name = "app",
        setup_description = "Fetch Dub dependencies (sdc debug)",
        compile_description = "Build D project with sdc (debug)",
        bundle_description = "Verify sdc debug build artifacts",
        test_description = "Run D tests with sdc (verbose)",
        test_args = "",
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
