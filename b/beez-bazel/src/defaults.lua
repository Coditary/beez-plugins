local M = {}

M.runnable = false

M.build_dir = "build/bazel"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.bazel_binary = "bazel"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bazel-setup]"
M.log_prefix_compile = "[bazel-compile]"
M.log_prefix_bundle = "[bazel-bundle]"
M.log_prefix_test = "[bazel-test]"


M.common_inputs = {
    "BUILD",
    "BUILD.bazel",
    "WORKSPACE",
    "WORKSPACE.bazel",
    "**/BUILD",
    "**/BUILD.bazel",
}

M.build_profiles = {
    code = {
        scope = "bazel",
        output_name = "build.ok",
        build_target = "//...",
        test_target = "//...",
        setup_description = "Verify Bazel CLI and workspace configuration",
        compile_description = "Build Bazel targets across the monorepo",
        bundle_description = "Verify Bazel build artifacts",
        test_description = "Run Bazel test targets",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        build_target = "//...",
        test_target = "//...",
        setup_description = "Verify Bazel CLI (debug)",
        compile_description = "Build Bazel targets with verbose output (debug)",
        bundle_description = "Verify Bazel debug build artifacts",
        test_description = "Run Bazel tests (verbose)",
        test_args = "--test_output=errors",
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
