local M = {}

M.runnable = true

M.build_dir = "build/janus"
M.bin_dir = M.build_dir .. "/bin"
M.obj_dir = M.build_dir .. "/obj"
M.reports_dir = "report"

M.janusada_binary = "janusada"
M.ada_binary = "ada"
M.link_binary = "link"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[janus-setup]"
M.log_prefix_compile = "[janus-compile]"
M.log_prefix_bundle = "[janus-bundle]"
M.log_prefix_test = "[janus-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ada",
    "**/*.adb",
    "**/*.ads",
}

M.build_profiles = {
    code = {
        scope = "janus",
        build_mode = "release",
        output_name = "app",
        optimize = "/O1 /3",
        debug_info = "",
        setup_description = "Verify Janus Ada toolchain and prepare build directories",
        compile_description = "Build Ada sources with Janus Ada (release, /O1 /3)",
        bundle_description = "Verify Janus Ada build artifacts",
        test_description = "Build and run Ada test programs with Janus Ada",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "janus",
        build_mode = "debug",
        output_name = "app",
        optimize = "",
        debug_info = "/D",
        setup_description = "Verify Janus Ada toolchain (debug profile)",
        compile_description = "Build Ada sources with Janus Ada (debug)",
        bundle_description = "Verify Janus Ada debug artifacts",
        test_description = "Run Ada tests with Janus Ada (debug)",
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
