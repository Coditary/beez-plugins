local M = {}

M.runnable = true

M.build_dir = "build/foxpro"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.vfp_binary = "vfp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[foxpro-setup]"
M.log_prefix_compile = "[foxpro-compile]"
M.log_prefix_bundle = "[foxpro-bundle]"
M.log_prefix_test = "[foxpro-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.prg",
    "**/*.scx",
}

M.compile_exclude = [[/(\.git|build)/]]

M.build_profiles = {
    code = {
        scope = "foxpro",
        output_name = "app",
        setup_description = "Verify Visual FoxPro compiler (vfp)",
        compile_description = "Compile FoxPro .prg sources to P-Code",
        bundle_description = "Verify FoxPro compile stamp",
        test_description = "Run FoxPro tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "foxpro",
        output_name = "app",
        setup_description = "Verify Visual FoxPro compiler (debug)",
        compile_description = "Compile FoxPro .prg sources (debug)",
        bundle_description = "Verify FoxPro debug compile stamp",
        test_description = "Run FoxPro tests (verbose)",
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
