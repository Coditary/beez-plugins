local M = {}

M.runnable = false

M.build_dir = "build/labview"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.labviewcli_binary = "LabVIEWCLI"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[labview-setup]"
M.log_prefix_compile = "[labview-compile]"
M.log_prefix_bundle = "[labview-bundle]"
M.log_prefix_test = "[labview-test]"


M.common_inputs = {
    "**/*.vi",
}

M.build_profiles = {
    code = {
        scope = "labview",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify LabVIEW toolchain and prepare build directories",
        compile_description = "Compile LabVIEW sources (labview)",
        bundle_description = "Verify LabVIEW build artifacts",
        test_description = "Run compiled LabVIEW binary or test suite",
        test_args = "",
    },

    debug = {
        scope = "labview",
        output_name = "app",
        optimize = "-g",
        setup_description = "Verify LabVIEW toolchain (debug profile)",
        compile_description = "Compile LabVIEW sources with debug info",
        bundle_description = "Verify LabVIEW debug build artifacts",
        test_description = "Run LabVIEW tests (debug profile)",
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
