local M = {}

M.runnable = true

M.build_dir = "build/mrustc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mrustc_binary = "mrustc"
M.minicargo_binary = "minicargo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mrustc-setup]"
M.log_prefix_compile = "[mrustc-compile]"
M.log_prefix_bundle = "[mrustc-bundle]"
M.log_prefix_test = "[mrustc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Cargo.toml",
    "Cargo.lock",
    "src/**/*.rs",
    "benches/**/*.rs",
    "examples/**/*.rs",
    "tests/**/*.rs",
}

M.build_profiles = {
    code = {
        scope = "mrustc",
        build_mode = "release",
        optimize = true,
        extra_args = {},
        setup_description = "Verify mrustc bootstrap compiler is available",
        compile_description = "Compile main crate with mrustc (no rustc toolchain required)",
        bundle_description = "Verify mrustc build artifacts",
        test_description = "Run crate tests via minicargo or smoke-test binary",
        test_args = "",
    },

    debug = {
        scope = "mrustc",
        build_mode = "debug",
        optimize = false,
        extra_args = { "-g" },
        setup_description = "Verify mrustc bootstrap compiler is available (debug)",
        compile_description = "Compile main crate with mrustc (debug)",
        bundle_description = "Verify mrustc debug artifacts",
        test_description = "Run crate tests with mrustc (verbose)",
        test_args = "-v",
    },
}

M.configure_step_profiles = {
    ["mrustc:configure"] = "code",
    ["mrustc:configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["mrustc:compile"] = "code",
    ["mrustc:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["mrustc:bundle"] = "code",
    ["mrustc:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["mrustc:test"] = "code",
    ["mrustc:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["mrustc:run"] = "code",
    ["mrustc:run:debug"] = "debug",
}

return M
