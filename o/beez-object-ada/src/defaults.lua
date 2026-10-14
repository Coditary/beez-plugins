local M = {}

M.runnable = true

M.build_dir = "build/object-ada"
M.bin_dir = M.build_dir .. "/bin"
M.obj_dir = M.build_dir .. "/obj"
M.reports_dir = "report"

M.ada_binary = "ada"
M.oc_binary = "oc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[object-ada-setup]"
M.log_prefix_compile = "[object-ada-compile]"
M.log_prefix_bundle = "[object-ada-bundle]"
M.log_prefix_test = "[object-ada-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.apr",
    "**/*.apr",
    "**/*.adb",
    "**/*.ads",
}

M.build_profiles = {
    code = {
        scope = "object-ada",
        build_mode = "release",
        output_name = "app",
        optimize = "-O2",
        debug_info = "",
        setup_description = "Verify ObjectAda toolchain and prepare build directories",
        compile_description = "Build Ada sources with ObjectAda (release, -O2)",
        bundle_description = "Verify ObjectAda build artifacts",
        test_description = "Build and run Ada test programs with ObjectAda",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "object-ada",
        build_mode = "debug",
        output_name = "app",
        optimize = "",
        debug_info = "-g",
        setup_description = "Verify ObjectAda toolchain (debug profile)",
        compile_description = "Build Ada sources with ObjectAda (debug)",
        bundle_description = "Verify ObjectAda debug artifacts",
        test_description = "Run Ada tests with ObjectAda (debug)",
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
