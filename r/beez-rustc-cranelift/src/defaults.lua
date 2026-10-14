local M = {}

M.runnable = true

M.target_dir = "target/cranelift"
M.bin_dir = M.target_dir .. "/debug"
M.reports_dir = "report"

M.cargo_binary = "cargo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.codegen_backend = "cranelift"

M.log_prefix_setup = "[rustc-cranelift-setup]"
M.log_prefix_compile = "[rustc-cranelift-compile]"
M.log_prefix_bundle = "[rustc-cranelift-bundle]"
M.log_prefix_test = "[rustc-cranelift-test]"

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
    debug = {
        scope = "cranelift",
        build_mode = "debug",
        cargo_profile = "dev",
        target_dir = M.target_dir,
        bin_dir = M.bin_dir,
        extra_args = {},
        setup_description = "Fetch Rust crate dependencies (cranelift)",
        compile_description = "Build Rust binaries with Cranelift backend (fast debug)",
        bundle_description = "Verify Cranelift debug binaries",
        test_description = "Run Rust tests with Cranelift backend",
        test_args = "",
        test_packages = "",
    },
}

M.configure_step_profiles = {
    ["rustc-cranelift:configure"] = "debug",
}

M.compile_step_profiles = {
    ["rustc-cranelift:compile"] = "debug",
}

M.bundle_step_profiles = {
    ["rustc-cranelift:bundle"] = "debug",
}

M.test_step_profiles = {
    ["rustc-cranelift:test"] = "debug",
}

M.run_step_profiles = {
    ["rustc-cranelift:run"] = "debug",
}

return M
