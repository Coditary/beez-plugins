local M = {}

M.runnable = true

M.build_dir = "build/smalltalk"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.gst_binary = "gst"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[smalltalk-setup]"
M.log_prefix_compile = "[smalltalk-compile]"
M.log_prefix_bundle = "[smalltalk-bundle]"
M.log_prefix_test = "[smalltalk-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.gst",
    "**/smalltalk/**/*.st",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "smalltalk",
        output_name = "app",
        setup_description = "Verify GNU Smalltalk and prepare build directory",
        compile_description = "Compile/validate GNU Smalltalk targets",
        bundle_description = "Verify smalltalk compile stamp",
        test_description = "Run primary GNU Smalltalk target",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "smalltalk",
        output_name = "app",
        setup_description = "Verify GNU Smalltalk and prepare build directory (debug)",
        compile_description = "Compile/validate GNU Smalltalk targets (debug)",
        bundle_description = "Verify smalltalk debug compile stamp",
        test_description = "Run primary GNU Smalltalk target (debug)",
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
