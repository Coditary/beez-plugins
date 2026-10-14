local M = {}

M.runnable = true

M.build_dir = "build/vbc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.vbc_binary = "vbc"
M.dotnet_binary = "dotnet"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[vbc-setup]"
M.log_prefix_compile = "[vbc-compile]"
M.log_prefix_bundle = "[vbc-bundle]"
M.log_prefix_test = "[vbc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.vbproj",
    "**/*.vbproj",
    "**/*.vb",
}

M.build_profiles = {
    code = {
        scope = "vbc",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify vbc/dotnet Visual Basic toolchain",
        compile_description = "Compile Visual Basic with vbc/dotnet",
        bundle_description = "Verify vbc build artifacts",
        test_description = "Run vbc tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        compile_flags = "/debug:full",
        setup_description = "Verify vbc/dotnet Visual Basic toolchain (debug)",
        compile_description = "Compile Visual Basic with vbc/dotnet (debug)",
        bundle_description = "Verify vbc debug artifacts",
        test_description = "Run vbc tests (verbose)",
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
