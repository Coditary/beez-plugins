local M = {}

M.runnable = true

M.build_dir = "build/reason"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.bsc_binary = "bsc"
M.refmt_binary = "refmt"
M.rescript_binary = "rescript"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[reason-setup]"
M.log_prefix_compile = "[reason-compile]"
M.log_prefix_bundle = "[reason-bundle]"
M.log_prefix_test = "[reason-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "bsconfig.json",
    "**/bsconfig.json",
    "rescript.json",
    "**/rescript.json",
    "**/*.re",
    "**/*.rei",
}

M.compile_exclude = [[/(\.git|build|node_modules|lib|bs)/]]

M.build_profiles = {
    code = {
        scope = "reason",
        output_name = "app",
        setup_description = "Verify refmt/bsc/rescript and install ReScript dependencies",
        compile_description = "Compile ReasonML/ReScript sources with bsc or rescript",
        bundle_description = "Verify Reason compile stamp",
        test_description = "Run ReScript/Reason tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "reason",
        output_name = "app",
        setup_description = "Verify refmt/bsc/rescript and install dependencies (debug)",
        compile_description = "Compile ReasonML/ReScript sources (debug)",
        bundle_description = "Verify Reason debug compile stamp",
        test_description = "Run ReScript/Reason tests (verbose)",
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
