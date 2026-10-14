local M = {}

M.runnable = false

M.build_dir = "build/yosys"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.yosys_binary = "yosys"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[yosys-setup]"
M.log_prefix_compile = "[yosys-compile]"
M.log_prefix_bundle = "[yosys-bundle]"
M.log_prefix_test = "[yosys-test]"


M.common_inputs = {
    "**/*.v",
    "**/*.sv",
}

M.build_profiles = {
    code = {
        scope = "yosys",
        output_name = "synth.v",
        setup_description = "Verify Yosys Verilog synthesis tool",
        compile_description = "Synthesize Verilog/SystemVerilog to netlist via Yosys",
        bundle_description = "Verify Yosys synthesis artifacts",
        test_description = "Validate Verilog design with Yosys check",
        synth_script = "synth",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "synth.v",
        setup_description = "Verify Yosys synthesis tool (debug)",
        compile_description = "Synthesize Verilog with Yosys debug/statistics output",
        bundle_description = "Verify Yosys debug synthesis artifacts",
        test_description = "Validate Verilog design (verbose Yosys check)",
        synth_script = "synth -debug",
        test_args = "-Q",
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


return M
