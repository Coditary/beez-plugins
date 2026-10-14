local M = {}

M.runnable = true

M.build_dir = "build/z88dk"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.zcc_binary = "zcc"
M.z88dk_target = "+zx"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[z88dk-setup]"
M.log_prefix_compile = "[z88dk-compile]"
M.log_prefix_bundle = "[z88dk-bundle]"
M.log_prefix_test = "[z88dk-test]"


M.common_inputs = {
    "**/*.c",
}

M.build_profiles = {
    code = {
        scope = "z88dk",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify z88dk Z80 cross-compiler (zcc)",
        compile_description = "Compile C to Z80 binary via zcc",
        bundle_description = "Verify z88dk build artifacts",
        test_description = "Run z88dk tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        optimize = "-O0",
        setup_description = "Verify z88dk Z80 cross-compiler (debug)",
        compile_description = "Compile C to Z80 binary (debug)",
        bundle_description = "Verify z88dk debug artifacts",
        test_description = "Run z88dk tests (verbose)",
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
