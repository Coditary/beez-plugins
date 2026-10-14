local M = {}

M.runnable = true

M.build_dir = "build/cim"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.cim_binary = "cim"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cim-setup]"
M.log_prefix_compile = "[cim-compile]"
M.log_prefix_bundle = "[cim-bundle]"
M.log_prefix_test = "[cim-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.sim",
}

M.compile_exclude = [[/(\.git|build)/]]

M.build_profiles = {
    code = {
        scope = "cim",
        output_name = "app",
        setup_description = "Verify GNU Cim Simula-to-C compiler",
        compile_description = "Compile Simula sources with cim",
        bundle_description = "Verify Cim compile stamp",
        test_description = "Run Cim/Simula tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "cim",
        output_name = "app",
        setup_description = "Verify GNU Cim compiler (debug)",
        compile_description = "Compile Simula sources with cim (debug)",
        bundle_description = "Verify Cim debug compile stamp",
        test_description = "Run Cim/Simula tests (verbose)",
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
