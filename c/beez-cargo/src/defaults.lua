local M = {}

M.runnable = true

M.target_dir = "target"
M.bin_dir = M.target_dir .. "/release"
M.debug_bin_dir = M.target_dir .. "/debug"
M.reports_dir = "report"

M.cargo_binary = "cargo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cargo-setup]"
M.log_prefix_compile = "[cargo-compile]"
M.log_prefix_bundle = "[cargo-bundle]"
M.log_prefix_test = "[cargo-test]"

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
        scope = "app",
        build_mode = "release",
        cargo_profile = "release",
        target_dir = M.target_dir,
        bin_dir = M.bin_dir,
        extra_args = {},
        setup_description = "Fetch Rust crate dependencies",
        compile_description = "Build Rust binaries (release, optimized)",
        bundle_description = "Verify release binaries",
        test_description = "Run Rust tests",
        test_args = "",
        test_packages = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        cargo_profile = "dev",
        target_dir = M.target_dir,
        bin_dir = M.debug_bin_dir,
        extra_args = {},
        setup_description = "Fetch Rust crate dependencies (debug)",
        compile_description = "Build Rust binaries (debug)",
        bundle_description = "Verify debug binaries",
        test_description = "Run Rust tests (verbose)",
        test_args = "-- --nocapture",
        test_packages = "",
    },

    coverage = {
        scope = "coverage",
        build_mode = "coverage",
        cargo_profile = "dev",
        target_dir = M.target_dir,
        bin_dir = M.debug_bin_dir,
        extra_args = {},
        setup_description = "Fetch Rust crate dependencies (coverage)",
        compile_description = "Build Rust binaries for coverage",
        bundle_description = "Verify coverage binaries",
        test_description = "Run Rust tests with llvm-cov (if available)",
        test_args = "",
        test_packages = "",
        use_llvm_cov = true,
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
    ["configure:coverage"] = "coverage",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
    ["compile:coverage"] = "coverage",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
    ["bundle:coverage"] = "coverage",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
    ["test:coverage"] = "coverage",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:coverage"] = "coverage",
    ["run:debug"] = "debug",
}

return M
