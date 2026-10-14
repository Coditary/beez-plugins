local M = {}

M.runnable = true

M.build_dir = "build/logtalk"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.logtalk_binary = "logtalk"
M.swipl_binary = "swipl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[logtalk-setup]"
M.log_prefix_compile = "[logtalk-compile]"
M.log_prefix_bundle = "[logtalk-bundle]"
M.log_prefix_test = "[logtalk-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.lgt",
    "**/*.logtalk",
}

M.build_profiles = {
    code = {
        scope = "logtalk",
        output_name = "app",
        setup_description = "Verify Logtalk and SWI-Prolog toolchain",
        compile_description = "Compile Logtalk sources on SWI-Prolog",
        bundle_description = "Verify Logtalk build artifacts",
        test_description = "Run Logtalk loader or test suite",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "logtalk",
        output_name = "app",
        setup_description = "Verify Logtalk toolchain (debug profile)",
        compile_description = "Check Logtalk sources with verbose diagnostics",
        bundle_description = "Verify Logtalk debug build artifacts",
        test_description = "Run Logtalk tests (debug profile)",
        test_args = "-v",
        run_description = "Run application (debug)",
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
