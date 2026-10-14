local M = {}

M.runnable = false

M.build_dir = "build/ninja"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ninja_binary = "ninja"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ninja-setup]"
M.log_prefix_compile = "[ninja-compile]"
M.log_prefix_bundle = "[ninja-bundle]"
M.log_prefix_test = "[ninja-test]"


M.common_inputs = {
    "build.ninja",
    "**/build.ninja",
}

M.build_profiles = {
    code = {
        scope = "ninja",
        output_name = "build.ok",
        setup_description = "Verify Ninja CLI and build.ninja manifest",
        compile_description = "Build targets from build.ninja",
        bundle_description = "Verify Ninja build artifacts",
        test_description = "Run Ninja test targets",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        setup_description = "Verify Ninja CLI (debug)",
        compile_description = "Build with verbose Ninja output (debug)",
        bundle_description = "Verify Ninja debug build artifacts",
        test_description = "Run Ninja test targets (verbose)",
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
