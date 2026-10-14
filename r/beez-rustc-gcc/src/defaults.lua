local M = {}

M.runnable = true

M.target_dir = "target/rustc-gcc"
M.bin_dir = M.target_dir .. "/release"
M.debug_bin_dir = M.target_dir .. "/debug"
M.reports_dir = "report"

M.cargo_binary = "cargo"
M.rustc_binary = "rustc"
M.codegen_backend = "gcc"
M.rustflags = "-C codegen-backend=gcc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[rustc-gcc-setup]"
M.log_prefix_compile = "[rustc-gcc-compile]"
M.log_prefix_bundle = "[rustc-gcc-bundle]"
M.log_prefix_test = "[rustc-gcc-test]"

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
        scope = "rustc-gcc",
        build_mode = "release",
        cargo_profile = "release",
        target_dir = M.target_dir,
        bin_dir = M.bin_dir,
        extra_args = {},
        setup_description = "Fetch Rust crate dependencies (rustc_codegen_gcc)",
        compile_description = "Build with rustc_codegen_gcc (GCC backend, release)",
        bundle_description = "Verify rustc-gcc release binaries",
        test_description = "Run Rust tests with rustc_codegen_gcc",
        test_args = "",
        test_packages = "",
    },

    debug = {
        scope = "rustc-gcc",
        build_mode = "debug",
        cargo_profile = "dev",
        target_dir = M.target_dir,
        bin_dir = M.debug_bin_dir,
        extra_args = {},
        setup_description = "Fetch Rust crate dependencies (rustc-gcc debug)",
        compile_description = "Build with rustc_codegen_gcc (debug)",
        bundle_description = "Verify rustc-gcc debug binaries",
        test_description = "Run Rust tests with rustc_codegen_gcc (verbose)",
        test_args = "-- --nocapture",
        test_packages = "",
    },
}

M.configure_step_profiles = {
    ["rustc-gcc:configure"] = "code",
    ["rustc-gcc:configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["rustc-gcc:compile"] = "code",
    ["rustc-gcc:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["rustc-gcc:bundle"] = "code",
    ["rustc-gcc:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["rustc-gcc:test"] = "code",
    ["rustc-gcc:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["rustc-gcc:run"] = "code",
    ["rustc-gcc:run:debug"] = "debug",
}

return M
