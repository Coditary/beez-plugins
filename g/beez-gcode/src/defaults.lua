local M = {}

M.runnable = true

M.build_dir = "build/gcode"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.gcode_binary = "camotics"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gcode-setup]"
M.log_prefix_compile = "[gcode-compile]"
M.log_prefix_bundle = "[gcode-bundle]"
M.log_prefix_test = "[gcode-test]"


M.common_inputs = {
    "**/*.gcode",
    "**/*.nc",
}

M.build_profiles = {
    code = {
        scope = "gcode",
        output_name = "app",
        setup_description = "Verify CAMotics G-code toolchain and prepare build directory",
        compile_description = "Validate and stage G-code CNC programs with camotics",
        bundle_description = "Verify staged G-code artifacts",
        test_description = "Simulate G-code toolpaths with camotics",
        test_args = "",
    },

    debug = {
        scope = "gcode",
        output_name = "app",
        setup_description = "Verify CAMotics G-code toolchain (debug)",
        compile_description = "Stage G-code programs without simulation (debug)",
        bundle_description = "Verify staged G-code debug artifacts",
        test_description = "Run extended G-code simulation checks",
        test_args = "-v",
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
