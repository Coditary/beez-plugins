local M = {}

M.runnable = true

M.build_dir = "build/mcs"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mcs_binary = "mcs"
M.dmcs_binary = "dmcs"
M.mono_binary = "mono"
M.test_runner = "nunit-console3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mcs-setup]"
M.log_prefix_compile = "[mcs-compile]"
M.log_prefix_bundle = "[mcs-bundle]"
M.log_prefix_test = "[mcs-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.csproj",
    "**/*.csproj",
    "**/*.cs",
}

M.build_profiles = {
    code = {
        scope = "mono",
        build_mode = "release",
        output_name = "app",
        optimize = true,
        debug_symbols = false,
        setup_description = "Prepare Mono C# build (mcs/dmcs)",
        compile_description = "Compile C# with mcs/dmcs (release)",
        bundle_description = "Verify mcs/dmcs build artifacts",
        test_description = "Run C# tests with nunit-console3",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "mono",
        build_mode = "debug",
        output_name = "app",
        optimize = false,
        debug_symbols = true,
        setup_description = "Prepare Mono C# build (mcs/dmcs debug)",
        compile_description = "Compile C# with mcs/dmcs (debug)",
        bundle_description = "Verify mcs/dmcs debug artifacts",
        test_description = "Run C# tests with nunit-console3 (verbose)",
        test_args = "--verbose",
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
