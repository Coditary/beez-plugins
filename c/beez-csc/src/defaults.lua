local M = {}

M.runnable = true

M.build_dir = "build/csc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dotnet_binary = "dotnet"
M.csc_binary = "csc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[csc-setup]"
M.log_prefix_compile = "[csc-compile]"
M.log_prefix_bundle = "[csc-bundle]"
M.log_prefix_test = "[csc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.csproj",
    "**/*.csproj",
    "*.sln",
    "**/*.sln",
    "**/*.cs",
}

M.build_profiles = {
    code = {
        scope = "app",
        build_mode = "release",
        configuration = "Release",
        output_name = "app",
        extra_args = {},
        setup_description = "Restore NuGet packages (dotnet restore)",
        compile_description = "Build C# project with Roslyn (Release)",
        bundle_description = "Verify C# build artifacts",
        test_description = "Run C# tests (dotnet test)",
        test_args = "--no-build -c Release",
        test_filter = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        configuration = "Debug",
        output_name = "app",
        extra_args = {},
        setup_description = "Restore NuGet packages (dotnet restore, debug)",
        compile_description = "Build C# project with Roslyn (Debug)",
        bundle_description = "Verify C# debug artifacts",
        test_description = "Run C# tests (dotnet test, verbose)",
        test_args = "--no-build -c Debug --verbosity normal",
        test_filter = "",
    },

    coverage = {
        scope = "coverage",
        build_mode = "coverage",
        configuration = "Debug",
        output_name = "app",
        extra_args = {},
        setup_description = "Restore NuGet packages (dotnet restore, coverage)",
        compile_description = "Build C# project for coverage",
        bundle_description = "Verify C# coverage artifacts",
        test_description = "Run C# tests with coverage collection",
        test_args = "--no-build -c Debug --collect:"XPlat Code Coverage"",
        test_filter = "",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
    ["configure:coverage"] = "coverage",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
    ["compile:coverage"] = "coverage",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
    ["bundle:coverage"] = "coverage",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
    ["test:coverage"] = "coverage",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:coverage"] = "coverage",
    ["run:debug"] = "debug",
}

return M
