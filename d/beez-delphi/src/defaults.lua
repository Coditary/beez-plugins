local M = {}

M.runnable = true

M.build_dir = "build/delphi"
M.bin_dir = M.build_dir .. "/bin"
M.dcu_dir = M.build_dir .. "/dcu"
M.reports_dir = "report"

M.delphi_binary = "dcc32"
M.delphi_binary_64 = "dcc64"
M.msbuild_binary = "msbuild"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[delphi-setup]"
M.log_prefix_compile = "[delphi-compile]"
M.log_prefix_bundle = "[delphi-bundle]"
M.log_prefix_test = "[delphi-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.dproj",
    "**/*.dproj",
    "*.dpr",
    "**/*.dpr",
    "**/*.pas",
}

M.build_profiles = {
    code = {
        scope = "delphi",
        build_mode = "release",
        configuration = "Release",
        platform = "Win32",
        output_name = "app",
        extra_args = {},
        unit_paths = {},
        setup_description = "Prepare Delphi build directories and verify compiler",
        compile_description = "Build Delphi project (Release, Win32)",
        bundle_description = "Verify Delphi build artifacts",
        test_description = "Run Delphi unit tests",
        test_args = "",
    },

    debug = {
        scope = "delphi",
        build_mode = "debug",
        configuration = "Debug",
        platform = "Win32",
        output_name = "app",
        extra_args = { "-V" },
        unit_paths = {},
        setup_description = "Prepare Delphi build directories (debug)",
        compile_description = "Build Delphi project (Debug, Win32)",
        bundle_description = "Verify Delphi debug artifacts",
        test_description = "Run Delphi unit tests (debug)",
        test_args = "",
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
