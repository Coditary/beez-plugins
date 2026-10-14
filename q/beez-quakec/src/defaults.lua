local M = {}

M.runnable = true

M.build_dir = "build/quakec"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.fteqcc_binary = "fteqcc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[quakec-setup]"
M.log_prefix_compile = "[quakec-compile]"
M.log_prefix_bundle = "[quakec-bundle]"
M.log_prefix_test = "[quakec-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.qc",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "quakec",
        output_name = "app",
        setup_description = "Verify QuakeC and prepare build directory",
        compile_description = "Compile/validate QuakeC targets",
        bundle_description = "Verify quakec compile stamp",
        test_description = "Run primary QuakeC target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "quakec",
        output_name = "app",
        setup_description = "Verify QuakeC and prepare build directory (debug)",
        compile_description = "Compile/validate QuakeC targets (debug)",
        bundle_description = "Verify quakec debug compile stamp",
        test_description = "Run primary QuakeC target (debug)",
        test_args = "",
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
