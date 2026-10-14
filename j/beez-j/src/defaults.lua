local M = {}

M.runnable = true

M.build_dir = "build/j"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.j_binary = "jconsole"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[j-setup]"
M.log_prefix_compile = "[j-compile]"
M.log_prefix_bundle = "[j-bundle]"
M.log_prefix_test = "[j-test]"
M.log_prefix_run = "[j-run]"

M.common_inputs = {
    "**/*.ijs"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify J runtime and prepare build directory",
        compile_description = "Validate J entry with jconsole",
        bundle_description = "Verify J compile stamp",
        test_description = "Run primary J entry",
        test_args = "",
        run_description = "Run J application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify J runtime (debug)",
        compile_description = "Validate J entry with jconsole (debug)",
        bundle_description = "Verify J debug compile stamp",
        test_description = "Run primary J entry (verbose)",
        test_args = "",
        run_description = "Run J application (debug)",
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
