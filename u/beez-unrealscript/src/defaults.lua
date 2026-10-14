local M = {}

M.runnable = true

M.build_dir = "build/unrealscript"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.unrealscript_binary = "ucc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[unrealscript-setup]"
M.log_prefix_compile = "[unrealscript-compile]"
M.log_prefix_bundle = "[unrealscript-bundle]"
M.log_prefix_test = "[unrealscript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.uc",
}

M.build_profiles = {
    code = {
        scope = "unrealscript",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify ucc and prepare build directory",
        compile_description = "Compile unrealscript sources (ucc)",
        bundle_description = "Verify unrealscript compile artifacts",
        test_description = "Verify unrealscript build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "unrealscript",
        output_name = "app",
        compile_flag = "-debug",
        setup_description = "Verify ucc and prepare build directory (debug)",
        compile_description = "Compile unrealscript sources with debug flags",
        bundle_description = "Verify unrealscript debug compile artifacts",
        test_description = "Verify unrealscript debug build output",
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
