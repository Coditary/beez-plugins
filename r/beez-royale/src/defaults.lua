local M = {}

M.runnable = false

M.build_dir = "build/royale"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.royale_binary = "royale"
M.asconfigc_binary = "asconfigc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[royale-setup]"
M.log_prefix_compile = "[royale-compile]"
M.log_prefix_bundle = "[royale-bundle]"
M.log_prefix_test = "[royale-test]"


M.common_inputs = {
    "asconfig.json",
    "**/asconfig.json",
    "**/*.as",
}

M.build_profiles = {
    code = {
        scope = "royale",
        output_name = "app",
        compile_flags = "",
        royale_target = "JSRoyale",
        setup_description = "Verify Apache Royale toolchain (royale/asconfigc)",
        compile_description = "Compile ActionScript to JavaScript with Apache Royale",
        bundle_description = "Verify Royale build artifacts",
        test_description = "Run Royale compile verification",
        test_args = "",
    },

    debug = {
        scope = "royale",
        output_name = "app",
        compile_flags = "-debug=true",
        royale_target = "JSRoyale",
        setup_description = "Verify Apache Royale toolchain (debug)",
        compile_description = "Compile ActionScript to JavaScript with Royale (debug)",
        bundle_description = "Verify Royale debug artifacts",
        test_description = "Run Royale tests (verbose)",
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
