local M = {}

M.runnable = true

M.build_dir = "build/peachpie"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.dotnet_binary = "dotnet"
M.sdk_name = "Peachpie.NET.Sdk"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[peachpie-setup]"
M.log_prefix_compile = "[peachpie-compile]"
M.log_prefix_bundle = "[peachpie-bundle]"
M.log_prefix_test = "[peachpie-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.phpproj",
    "**/*.phpproj",
    "composer.json",
    "**/composer.json",
    "**/*.php",
}

M.build_profiles = {
    code = {
        scope = "peachpie",
        build_mode = "release",
        configuration = "Release",
        output_name = "app",
        extra_args = {},
        setup_description = "Restore NuGet packages for Peachpie project (dotnet restore)",
        compile_description = "Build PHP project with Peachpie.NET.Sdk (Release)",
        bundle_description = "Verify Peachpie build artifacts",
        test_description = "Run Peachpie tests (dotnet test)",
        test_args = "--no-build -c Release",
        test_filter = "",
    },

    debug = {
        scope = "peachpie",
        build_mode = "debug",
        configuration = "Debug",
        output_name = "app",
        extra_args = {},
        setup_description = "Restore NuGet packages for Peachpie project (debug)",
        compile_description = "Build PHP project with Peachpie.NET.Sdk (Debug)",
        bundle_description = "Verify Peachpie debug artifacts",
        test_description = "Run Peachpie tests (dotnet test, verbose)",
        test_args = "--no-build -c Debug --verbosity normal",
        test_filter = "",
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
