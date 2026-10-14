local M = {}

M.runnable = false

M.build_dir = "build/tlaplus"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.tlc_binary = "tlc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tlaplus-setup]"
M.log_prefix_compile = "[tlaplus-compile]"
M.log_prefix_bundle = "[tlaplus-bundle]"
M.log_prefix_test = "[tlaplus-test]"


M.common_inputs = {
    "**/*.tla",
    "**/*.cfg",
}

M.build_profiles = {
    code = {
        scope = "tlaplus",
        output_name = "check.out",
        setup_description = "Verify TLC model checker binary",
        compile_description = "Run TLC model checker on TLA+ spec",
        bundle_description = "Verify TLC model check artifacts",
        test_description = "Validate TLA+ spec with TLC",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "check-debug.out",
        setup_description = "Verify TLC model checker binary (debug)",
        compile_description = "Run TLC model checker with debug output",
        bundle_description = "Verify TLC debug check artifacts",
        test_description = "Validate TLA+ spec with TLC (verbose)",
        test_args = "-debug",
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
