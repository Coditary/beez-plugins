local M = {}

M.runnable = false

M.build_dir = "build/ghidra"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ghidra_binary = "analyzeHeadless"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ghidra-setup]"
M.log_prefix_compile = "[ghidra-compile]"
M.log_prefix_bundle = "[ghidra-bundle]"
M.log_prefix_test = "[ghidra-test]"


M.common_inputs = {
    "**/*",
}

M.build_profiles = {
    code = {
        scope = "ghidra",
        output_name = "analyze.ok",
        report_name = "analysis.log",
        setup_description = "Verify Ghidra analyzeHeadless and prepare project workspace",
        compile_description = "Run Ghidra headless analysis on detected binaries",
        bundle_description = "Verify Ghidra analysis artifacts",
        test_description = "Validate Ghidra analysis output and project state",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "analyze.ok",
        report_name = "analysis-debug.log",
        setup_description = "Verify Ghidra analyzeHeadless (debug)",
        compile_description = "Run Ghidra headless analysis with verbose logging (debug)",
        bundle_description = "Verify Ghidra debug analysis artifacts",
        test_description = "Validate Ghidra analysis output (verbose)",
        test_args = "-log",
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
