local M = {}

M.runnable = true

M.build_dir = "build/oxygene"
M.bin_dir = M.build_dir .. "/bin"
M.obj_dir = M.build_dir .. "/obj"
M.reports_dir = "report"

M.msbuild_binary = "msbuild"
M.elements_binary = "Elements"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[oxygene-setup]"
M.log_prefix_compile = "[oxygene-compile]"
M.log_prefix_bundle = "[oxygene-bundle]"
M.log_prefix_test = "[oxygene-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.oxygene",
    "**/*.oxygene",
    "*.elements",
    "**/*.elements",
    "*.pas",
    "**/*.pas",
}

M.build_profiles = {
    code = {
        scope = "oxygene",
        build_mode = "release",
        configuration = "Release",
        platform = "Any CPU",
        output_name = "app",
        extra_args = {},
        unit_paths = {},
        setup_description = "Prepare Oxygene build directories and verify toolchain",
        compile_description = "Build Oxygene project (Release)",
        bundle_description = "Verify Oxygene build artifacts",
        test_description = "Run Oxygene unit tests",
        test_args = "",
    },

    debug = {
        scope = "oxygene",
        build_mode = "debug",
        configuration = "Debug",
        platform = "Any CPU",
        output_name = "app",
        extra_args = {},
        unit_paths = {},
        setup_description = "Prepare Oxygene build directories (debug)",
        compile_description = "Build Oxygene project (Debug)",
        bundle_description = "Verify Oxygene debug artifacts",
        test_description = "Run Oxygene unit tests (debug)",
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
