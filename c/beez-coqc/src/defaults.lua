local M = {}

M.runnable = false

M.build_dir = "build/coqc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.coqc_binary = "coqc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[coqc-setup]"
M.log_prefix_compile = "[coqc-compile]"
M.log_prefix_bundle = "[coqc-bundle]"
M.log_prefix_test = "[coqc-test]"


M.common_inputs = {
    "_CoqProject",
    "**/_CoqProject",
    "**/*.v",
}

M.compile_exclude = [[/(\.git|build|\.venv|local|target|_build)/]]

M.build_profiles = {
    code = {
        scope = "coqc",
        output_name = "app",
        setup_description = "Verify coqc and prepare build directory",
        compile_description = "Compile/type-check coqc sources",
        bundle_description = "Verify coqc compile stamp",
        test_description = "Run coqc tests",
        test_args = "",
    },

    debug = {
        scope = "coqc",
        output_name = "app",
        setup_description = "Verify coqc and prepare build directory (debug)",
        compile_description = "Compile/type-check coqc sources (debug)",
        bundle_description = "Verify coqc debug compile stamp",
        test_description = "Run coqc tests (verbose)",
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
