local M = {}

M.runnable = true

M.build_dir = "build/nim-csources"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.cc_binary = "gcc"
M.nim_bootstrap_name = "nim_csources"
M.nim_binary = "nim"
M.koch_binary = "koch"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nim-csources-setup]"
M.log_prefix_compile = "[nim-csources-compile]"
M.log_prefix_bundle = "[nim-csources-bundle]"
M.log_prefix_test = "[nim-csources-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "compiler/nim.nim",
    "**/*.nim",
    "build_nim.sh",
    "koch.nim",
    "config/build_config.txt",
    "csources/**",
    "csources_v1/**",
    "csources_v2/**",
    "csources_v3/**",
}

M.csources_dir_candidates = {
    "csources_v3",
    "csources_v2",
    "csources_v1",
    "csources",
}

M.build_profiles = {
    code = {
        scope = "csources",
        release = true,
        boot_args = "-d:release",
        setup_description = "Build Nim csources bootstrap compiler with GCC/Clang",
        compile_description = "Bootstrap Nim compiler from csources via koch",
        bundle_description = "Verify bootstrapped Nim compiler artifacts",
        test_description = "Run Nim bootstrap smoke tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "csources",
        release = false,
        boot_args = "",
        setup_description = "Build Nim csources bootstrap compiler (debug)",
        compile_description = "Bootstrap Nim compiler from csources (debug)",
        bundle_description = "Verify bootstrapped Nim debug artifacts",
        test_description = "Run Nim bootstrap smoke tests (verbose)",
        test_args = "--verbose",
        run_description = "Run application (debug)",
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

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
