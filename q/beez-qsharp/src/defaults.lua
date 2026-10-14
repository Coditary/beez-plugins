local M = {}

M.runnable = true

M.build_dir = "build/qsharp"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.dotnet_binary = "dotnet"
M.qsc_binary = "qsc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[qsharp-setup]"
M.log_prefix_compile = "[qsharp-compile]"
M.log_prefix_bundle = "[qsharp-bundle]"
M.log_prefix_test = "[qsharp-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.qs",
    "*.csproj",
    "**/*.csproj",
}

M.build_profiles = {
    code = {
        scope = "qsharp",
        output_name = "app",
        setup_description = "Verify .NET SDK and Q# compiler (QDK→QIR)",
        compile_description = "Compile Q# to QIR via dotnet build or qsc",
        bundle_description = "Verify Q# build artifacts",
        test_description = "Run Q# tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify .NET SDK and Q# compiler (debug)",
        compile_description = "Compile Q# to QIR (debug)",
        bundle_description = "Verify Q# debug artifacts",
        test_description = "Run Q# tests (verbose)",
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
