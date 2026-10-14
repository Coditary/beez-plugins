local M = {}

M.runnable = true

M.build_dir = "build/moarvm"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.moar_binary = "moar"
M.nqp_binary = "nqp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[moarvm-setup]"
M.log_prefix_compile = "[moarvm-compile]"
M.log_prefix_bundle = "[moarvm-bundle]"
M.log_prefix_test = "[moarvm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.moar",
    "**/*.nqp",
}

M.build_profiles = {
    code = {
        scope = "moarvm",
        compile_mode = "nqp",
        setup_description = "Verify MoarVM and NQP binaries",
        compile_description = "Compile NQP sources and verify MoarVM bytecode",
        bundle_description = "Verify MoarVM compile artifacts",
        test_description = "Run NQP/MoarVM tests in t/",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        compile_mode = "verbose",
        setup_description = "Verify MoarVM and NQP binaries (debug)",
        compile_description = "Compile NQP sources with verbose output",
        bundle_description = "Verify MoarVM debug compile artifacts",
        test_description = "Run NQP/MoarVM tests (verbose)",
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
