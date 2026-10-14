local M = {}

M.runnable = true

M.build_dir = "build/cue"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.cue_binary = "cue"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[cue-setup]"
M.log_prefix_compile = "[cue-compile]"
M.log_prefix_bundle = "[cue-bundle]"
M.log_prefix_test = "[cue-test]"
M.log_prefix_run = "[cue-run]"

M.common_inputs = {
    "**/*.cue",
    "cue.mod/module.cue",
}

M.build_profiles = {
    code = {
        scope = "cue",
        output_name = "export.json",
        setup_description = "Verify CUE CLI and module dependencies",
        compile_description = "Export and unify CUE configuration",
        bundle_description = "Verify CUE export artifacts",
        test_description = "Validate CUE configuration and formatting",
        test_args = "",
        run_args = "",
        run_description = "Evaluate CUE configuration (cue eval)",
    },

    debug = {
        scope = "debug",
        output_name = "export.json",
        setup_description = "Verify CUE CLI (debug)",
        compile_description = "Export CUE configuration with verbose output (debug)",
        bundle_description = "Verify CUE debug export artifacts",
        test_description = "Validate CUE configuration (verbose)",
        test_args = "-v",
        run_args = "-v",
        run_description = "Evaluate CUE configuration (cue eval, verbose)",
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
