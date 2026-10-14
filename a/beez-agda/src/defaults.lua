local M = {}

M.runnable = false

M.build_dir = "build/agda"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.agda_binary = "agda"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[agda-setup]"
M.log_prefix_compile = "[agda-compile]"
M.log_prefix_bundle = "[agda-bundle]"
M.log_prefix_test = "[agda-test]"


M.common_inputs = {
    "**/*.agda",
}

M.compile_exclude = [[/(\.git|build|\.venv|local|target|_build)/]]

M.build_profiles = {
    code = {
        scope = "agda",
        output_name = "app",
        setup_description = "Verify agda and prepare build directory",
        compile_description = "Compile/type-check agda sources",
        bundle_description = "Verify agda compile stamp",
        test_description = "Run agda tests",
        test_args = "",
    },

    debug = {
        scope = "agda",
        output_name = "app",
        setup_description = "Verify agda and prepare build directory (debug)",
        compile_description = "Compile/type-check agda sources (debug)",
        bundle_description = "Verify agda debug compile stamp",
        test_description = "Run agda tests (verbose)",
        test_args = "-v",
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
