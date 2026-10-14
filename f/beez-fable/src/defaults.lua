local M = {}

M.runnable = true

M.build_dir = "build/fable"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dotnet_binary = "dotnet"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fable-setup]"
M.log_prefix_compile = "[fable-compile]"
M.log_prefix_bundle = "[fable-bundle]"
M.log_prefix_test = "[fable-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.fsproj",
    "**/*.fsproj",
    "*.sln",
    "**/*.sln",
    "**/*.fs",
}

M.build_profiles = {
    code = {
        scope = "fable",
        build_mode = "release",
        configuration = "Release",
        output_name = "app",
        out_dir_flag = "-o",
        extra_args = {},
        setup_description = "Restore NuGet packages (dotnet restore)",
        compile_description = "Transpile F# to JavaScript/TypeScript (dotnet fable)",
        bundle_description = "Verify Fable build artifacts",
        test_description = "Run F# tests (dotnet test)",
        test_args = "--no-build -c Release",
        test_filter = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        configuration = "Debug",
        output_name = "app",
        out_dir_flag = "-o",
        extra_args = {},
        setup_description = "Restore NuGet packages (dotnet restore, debug)",
        compile_description = "Transpile F# to JavaScript/TypeScript (dotnet fable, debug)",
        bundle_description = "Verify Fable debug artifacts",
        test_description = "Run F# tests (dotnet test, verbose)",
        test_args = "--no-build -c Debug --verbosity normal",
        test_filter = "",
    },

    coverage = {
        scope = "coverage",
        build_mode = "coverage",
        configuration = "Debug",
        output_name = "app",
        out_dir_flag = "-o",
        extra_args = {},
        setup_description = "Restore NuGet packages (dotnet restore, coverage)",
        compile_description = "Transpile F# for coverage workflow",
        bundle_description = "Verify Fable coverage artifacts",
        test_description = "Run F# tests with coverage collection",
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
