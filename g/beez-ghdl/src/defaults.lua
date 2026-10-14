local M = {}

M.runnable = true

M.build_dir = "build/ghdl"
M.bin_dir = M.build_dir .. "/bin"
M.work_dir = M.build_dir .. "/work"
M.reports_dir = "report"

M.ghdl_binary = "ghdl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ghdl-setup]"
M.log_prefix_compile = "[ghdl-compile]"
M.log_prefix_bundle = "[ghdl-bundle]"
M.log_prefix_test = "[ghdl-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.vhdl",
    "**/*.vhd",
}

M.build_profiles = {
    code = {
        scope = "ghdl",
        output_name = "app",
        setup_description = "Verify GHDL VHDL compiler binary",
        compile_description = "Analyze, elaborate, and build VHDL design",
        bundle_description = "Verify GHDL build artifacts",
        test_description = "Run GHDL simulation testbench",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify GHDL compiler binary (debug)",
        compile_description = "Analyze and build VHDL design (debug)",
        bundle_description = "Verify GHDL debug artifacts",
        test_description = "Run GHDL simulation (verbose)",
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
