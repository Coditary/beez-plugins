local M = {}

M.runnable = false

M.build_dir = "build/radare2"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.r2_binary = "r2"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[radare2-setup]"
M.log_prefix_compile = "[radare2-compile]"
M.log_prefix_bundle = "[radare2-bundle]"
M.log_prefix_test = "[radare2-test]"


M.common_inputs = {
    "**/*",
}

M.build_profiles = {
    code = {
        scope = "radare2",
        output_name = "analyze.ok",
        report_name = "analysis.txt",
        setup_description = "Verify radare2 CLI and prepare analysis workspace",
        compile_description = "Run radare2 auto-analysis on detected binaries",
        bundle_description = "Verify radare2 analysis artifacts",
        test_description = "Validate radare2 analysis output",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "analyze.ok",
        report_name = "analysis-debug.txt",
        setup_description = "Verify radare2 CLI (debug)",
        compile_description = "Run radare2 analysis with verbose output (debug)",
        bundle_description = "Verify radare2 debug analysis artifacts",
        test_description = "Validate radare2 analysis output (verbose)",
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
