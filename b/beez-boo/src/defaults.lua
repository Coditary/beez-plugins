local M = {}

M.runnable = true

M.build_dir = "build/boo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.boo_binary = "booc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[boo-setup]"
M.log_prefix_compile = "[boo-compile]"
M.log_prefix_bundle = "[boo-bundle]"
M.log_prefix_test = "[boo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.boo",
}

M.build_profiles = {
    code = {
        scope = "boo",
        output_name = "app",
        compile_flag = "-debug-",
        setup_description = "Verify booc and prepare build directory",
        compile_description = "Compile Boo sources (booc)",
        bundle_description = "Verify Boo compile artifacts",
        test_description = "Verify Boo build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "boo",
        output_name = "app",
        compile_flag = "-debug+",
        setup_description = "Verify booc and prepare build directory (debug)",
        compile_description = "Compile Boo sources with debug flags",
        bundle_description = "Verify Boo debug compile artifacts",
        test_description = "Verify Boo debug build output",
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
