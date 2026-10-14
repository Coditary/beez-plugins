local M = {}

M.runnable = false

M.build_dir = "build/nsis"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.makensis_binary = "makensis"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nsis-setup]"
M.log_prefix_compile = "[nsis-compile]"
M.log_prefix_bundle = "[nsis-bundle]"
M.log_prefix_test = "[nsis-test]"


M.common_inputs = {
    "**/*.nsi",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "nsis",
        output_name = "app",
        setup_description = "Verify NSIS and prepare build directory",
        compile_description = "Compile/validate NSIS targets",
        bundle_description = "Verify nsis compile stamp",
        test_description = "Run primary NSIS target",
        test_args = "",
    },

    debug = {
        scope = "nsis",
        output_name = "app",
        setup_description = "Verify NSIS and prepare build directory (debug)",
        compile_description = "Compile/validate NSIS targets (debug)",
        bundle_description = "Verify nsis debug compile stamp",
        test_description = "Run primary NSIS target (debug)",
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
