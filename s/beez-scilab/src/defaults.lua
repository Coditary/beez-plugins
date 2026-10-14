local M = {}

M.runnable = true

M.build_dir = "build/scilab"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.scilab_binary = "scilab-adv-cli"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[scilab-setup]"
M.log_prefix_compile = "[scilab-compile]"
M.log_prefix_bundle = "[scilab-bundle]"
M.log_prefix_test = "[scilab-test]"
M.log_prefix_run = "[scilab-run]"

M.common_inputs = {
    "**/*.sce",
    "**/*.sci"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "-nwn -f",
        setup_description = "Verify Scilab runtime and prepare build directory",
        compile_description = "Validate Scilab entry with scilab-adv-cli",
        bundle_description = "Verify Scilab compile stamp",
        test_description = "Run primary Scilab entry",
        test_args = "",
        run_description = "Run Scilab application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "-nwn -f",
        setup_description = "Verify Scilab runtime (debug)",
        compile_description = "Validate Scilab entry with scilab-adv-cli (debug)",
        bundle_description = "Verify Scilab debug compile stamp",
        test_description = "Run primary Scilab entry (verbose)",
        test_args = "",
        run_description = "Run Scilab application (debug)",
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
