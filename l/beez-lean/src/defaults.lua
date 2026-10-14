local M = {}

M.runnable = false

M.build_dir = "build/lean"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.lake_binary = "lake"
M.lean_binary = "lean"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[lean-setup]"
M.log_prefix_compile = "[lean-compile]"
M.log_prefix_bundle = "[lean-bundle]"
M.log_prefix_test = "[lean-test]"


M.common_inputs = {
    "lakefile.lean",
    "**/lakefile.lean",
    "**/*.lean",
}

M.build_profiles = {
    code = {
        scope = "lean",
        output_name = "app",
        setup_description = "Verify lake/lean binaries and prepare build directory",
        compile_description = "Build Lean 4 project with lake build",
        bundle_description = "Verify Lean build artifacts in .lake/build",
        test_description = "Run Lean tests with lake test",
        test_args = "",
    },

    debug = {
        scope = "lean",
        output_name = "app",
        setup_description = "Verify lake/lean binaries and prepare build directory (debug)",
        compile_description = "Build Lean 4 project with lake build (debug)",
        bundle_description = "Verify Lean build artifacts in .lake/build (debug)",
        test_description = "Run Lean tests with lake test (verbose)",
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
