local M = {}

M.runnable = true

M.build_dir = "build/netrexx"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.netrexx_binary = "netrexxc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[netrexx-setup]"
M.log_prefix_compile = "[netrexx-compile]"
M.log_prefix_bundle = "[netrexx-bundle]"
M.log_prefix_test = "[netrexx-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.nrx",
}

M.build_profiles = {
    code = {
        scope = "netrexx",
        output_name = "app",
        setup_description = "Verify NetRexx toolchain and prepare build directory",
        compile_description = "Compile NetRexx sources ",
        bundle_description = "Verify NetRexx compile artifacts",
        test_description = "Run NetRexx compiled output",
        test_args = "",
        compile_flags = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "netrexx",
        output_name = "app",
        setup_description = "Verify NetRexx toolchain and prepare build directory (debug)",
        compile_description = "Compile NetRexx sources with debug info",
        bundle_description = "Verify NetRexx debug compile artifacts",
        test_description = "Run NetRexx compiled output (verbose)",
        test_args = "-v",
        compile_flags = "-verbose",
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
