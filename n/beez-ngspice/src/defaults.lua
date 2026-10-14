local M = {}

M.runnable = true

M.build_dir = "build/ngspice"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.ngspice_binary = "ngspice"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[ngspice-setup]"
M.log_prefix_compile = "[ngspice-compile]"
M.log_prefix_bundle = "[ngspice-bundle]"
M.log_prefix_test = "[ngspice-test]"
M.log_prefix_run = "[ngspice-run]"

M.common_inputs = {
    "**/*.cir",
    "**/*.sp",
    "**/*.net"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {"-b"},
        setup_description = "Verify Ngspice runtime and prepare build directory",
        compile_description = "Validate Ngspice entry with ngspice",
        bundle_description = "Verify Ngspice compile stamp",
        test_description = "Run primary Ngspice entry",
        test_args = "",
        run_description = "Run Ngspice application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {"-b"},
        setup_description = "Verify Ngspice runtime (debug)",
        compile_description = "Validate Ngspice entry with ngspice (debug)",
        bundle_description = "Verify Ngspice debug compile stamp",
        test_description = "Run primary Ngspice entry (verbose)",
        test_args = "",
        run_description = "Run Ngspice application (debug)",
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
