local M = {}

M.runnable = false

M.build_dir = "build/icestorm"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.yosys_binary = "yosys"
M.nextpnr_binary = "nextpnr-ice40"
M.icepack_binary = "icepack"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[icestorm-setup]"
M.log_prefix_compile = "[icestorm-compile]"
M.log_prefix_bundle = "[icestorm-bundle]"
M.log_prefix_test = "[icestorm-test]"


M.common_inputs = {
    "**/*.pcf",
    "**/*.v",
    "**/*.sv",
}

M.build_profiles = {
    code = {
        scope = "icestorm",
        fpga_device = "hx8k",
        fpga_package = "ct256",
        output_name = "top.bin",
        setup_description = "Verify Project IceStorm FPGA toolchain",
        compile_description = "Synthesize and place/route ice40 design to bitstream",
        bundle_description = "Verify IceStorm bitstream artifacts",
        test_description = "Validate ice40 design with Yosys check",
        test_args = "",
    },

    debug = {
        scope = "debug",
        fpga_device = "hx8k",
        fpga_package = "ct256",
        output_name = "top.bin",
        setup_description = "Verify Project IceStorm toolchain (debug)",
        compile_description = "Build ice40 bitstream with verbose nextpnr output",
        bundle_description = "Verify IceStorm debug bitstream artifacts",
        test_description = "Validate ice40 design (verbose check)",
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
