local M = {}

M.runnable = true

M.build_dir = "build/nemerle"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.nemerle_binary = "ncc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nemerle-setup]"
M.log_prefix_compile = "[nemerle-compile]"
M.log_prefix_bundle = "[nemerle-bundle]"
M.log_prefix_test = "[nemerle-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.n",
}

M.build_profiles = {
    code = {
        scope = "nemerle",
        output_name = "app",
        setup_description = "Verify Nemerle toolchain and prepare build directory",
        compile_description = "Compile Nemerle sources ",
        bundle_description = "Verify Nemerle compile artifacts",
        test_description = "Run Nemerle compiled output",
        test_args = "",
        compile_flags = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "nemerle",
        output_name = "app",
        setup_description = "Verify Nemerle toolchain and prepare build directory (debug)",
        compile_description = "Compile Nemerle sources with debug info",
        bundle_description = "Verify Nemerle debug compile artifacts",
        test_description = "Run Nemerle compiled output (verbose)",
        test_args = "-v",
        compile_flags = "-debug",
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
