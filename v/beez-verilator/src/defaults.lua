local M = {}

M.runnable = true

M.build_dir = "build/verilator"
M.bin_dir = M.build_dir .. "/bin"
M.obj_dir = M.build_dir .. "/obj"
M.reports_dir = "report"

M.verilator_binary = "verilator"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[verilator-setup]"
M.log_prefix_compile = "[verilator-compile]"
M.log_prefix_bundle = "[verilator-bundle]"
M.log_prefix_test = "[verilator-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.v",
    "**/*.sv",
}

M.build_profiles = {
    code = {
        scope = "verilator",
        output_name = "app",
        setup_description = "Verify Verilator Verilog compiler binary",
        compile_description = "Compile Verilog/SystemVerilog to C++ simulation binary",
        bundle_description = "Verify Verilator build artifacts",
        test_description = "Run Verilator simulation binary",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Verilator compiler binary (debug)",
        compile_description = "Compile Verilog/SystemVerilog (debug, trace enabled)",
        bundle_description = "Verify Verilator debug artifacts",
        test_description = "Run Verilator simulation (verbose)",
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
