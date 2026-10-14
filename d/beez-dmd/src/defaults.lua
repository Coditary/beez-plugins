local M = {}

M.runnable = true

M.build_dir = "build/dmd"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.dmd_binary = "dmd"
M.dub_binary = "dub"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dmd-setup]"
M.log_prefix_compile = "[dmd-compile]"
M.log_prefix_bundle = "[dmd-bundle]"
M.log_prefix_test = "[dmd-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dub.json",
    "dub.sdl",
    "**/*.d",
}

M.build_profiles = {
    code = {
        scope = "dmd",
        build_mode = "release",
        dub_build = "release",
        dmd_flags = { "-O", "-release" },
        output_name = "app",
        setup_description = "Fetch Dub dependencies (dmd release)",
        compile_description = "Build D project with dmd (release)",
        bundle_description = "Verify dmd release build artifacts",
        test_description = "Run D tests with dmd",
        test_args = "",
    },

    debug = {
        scope = "dmd",
        build_mode = "debug",
        dub_build = "debug",
        dmd_flags = { "-g", "-debug" },
        output_name = "app",
        setup_description = "Fetch Dub dependencies (dmd debug)",
        compile_description = "Build D project with dmd (debug)",
        bundle_description = "Verify dmd debug build artifacts",
        test_description = "Run D tests with dmd (verbose)",
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
