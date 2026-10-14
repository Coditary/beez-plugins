local M = {}

M.runnable = false

M.build_dir = "build/povray"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.povray_binary = "povray"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[povray-setup]"
M.log_prefix_compile = "[povray-compile]"
M.log_prefix_bundle = "[povray-bundle]"
M.log_prefix_test = "[povray-test]"


M.common_inputs = {
    "**/*.pov",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "povray",
        output_name = "app",
        setup_description = "Verify POV-Ray and prepare build directory",
        compile_description = "Compile/validate POV-Ray targets",
        bundle_description = "Verify povray compile stamp",
        test_description = "Run primary POV-Ray target",
        test_args = "",
    },

    debug = {
        scope = "povray",
        output_name = "app",
        setup_description = "Verify POV-Ray and prepare build directory (debug)",
        compile_description = "Compile/validate POV-Ray targets (debug)",
        bundle_description = "Verify povray debug compile stamp",
        test_description = "Run primary POV-Ray target (debug)",
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


return M
