local M = {}

M.runnable = false

M.build_dir = "build/zpl"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.curl_binary = "curl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[zpl-setup]"
M.log_prefix_compile = "[zpl-compile]"
M.log_prefix_bundle = "[zpl-bundle]"
M.log_prefix_test = "[zpl-test]"


M.common_inputs = {
    "**/*.zpl",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "zpl",
        output_name = "app",
        setup_description = "Verify ZPL and prepare build directory",
        compile_description = "Compile/validate ZPL targets",
        bundle_description = "Verify zpl compile stamp",
        test_description = "Run primary ZPL target",
        test_args = "",
    },

    debug = {
        scope = "zpl",
        output_name = "app",
        setup_description = "Verify ZPL and prepare build directory (debug)",
        compile_description = "Compile/validate ZPL targets (debug)",
        bundle_description = "Verify zpl debug compile stamp",
        test_description = "Run primary ZPL target (debug)",
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
