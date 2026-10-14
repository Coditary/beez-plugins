local M = {}

M.runnable = false

M.build_dir = "build/postscript"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.gs_binary = "gs"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[postscript-setup]"
M.log_prefix_compile = "[postscript-compile]"
M.log_prefix_bundle = "[postscript-bundle]"
M.log_prefix_test = "[postscript-test]"


M.common_inputs = {
    "**/*.ps",
    "**/*.eps",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "postscript",
        output_name = "app",
        setup_description = "Verify PostScript and prepare build directory",
        compile_description = "Compile/validate PostScript targets",
        bundle_description = "Verify postscript compile stamp",
        test_description = "Run primary PostScript target",
        test_args = "",
    },

    debug = {
        scope = "postscript",
        output_name = "app",
        setup_description = "Verify PostScript and prepare build directory (debug)",
        compile_description = "Compile/validate PostScript targets (debug)",
        bundle_description = "Verify postscript debug compile stamp",
        test_description = "Run primary PostScript target (debug)",
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
