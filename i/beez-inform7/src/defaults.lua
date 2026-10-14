local M = {}

M.runnable = false

M.build_dir = "build/inform7"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.inform7_binary = "inform7"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[inform7-setup]"
M.log_prefix_compile = "[inform7-compile]"
M.log_prefix_bundle = "[inform7-bundle]"
M.log_prefix_test = "[inform7-test]"


M.common_inputs = {
    "**/*.i7x",
    "**/*.i7source",
}

M.build_profiles = {
    code = {
        scope = "inform7",
        output_name = "app",
        setup_description = "Verify inform7 binary and prepare build directory",
        compile_description = "Compile Inform 7 sources to story file with inform7",
        bundle_description = "Verify Inform 7 story file artifacts",
        test_description = "Verify Inform 7 build outputs exist",
        test_args = "",
    },

    debug = {
        scope = "inform7",
        output_name = "app",
        setup_description = "Verify inform7 binary and prepare build directory (debug)",
        compile_description = "Compile Inform 7 sources to story file with inform7 (debug)",
        bundle_description = "Verify Inform 7 story file artifacts (debug)",
        test_description = "Verify Inform 7 build outputs exist (verbose)",
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
