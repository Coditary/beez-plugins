local M = {}

M.runnable = false

M.build_dir = "build/nix"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.nix_binary = "nix"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nix-setup]"
M.log_prefix_compile = "[nix-compile]"
M.log_prefix_bundle = "[nix-bundle]"
M.log_prefix_test = "[nix-test]"


M.common_inputs = {
    "flake.nix",
    "**/*.nix",
    "default.nix",
}

M.build_profiles = {
    code = {
        scope = "nix",
        output_name = "build.ok",
        result_link = "result",
        setup_description = "Verify Nix CLI and evaluate project expressions",
        compile_description = "Build or check Nix flake/default.nix expressions",
        bundle_description = "Verify Nix build artifacts",
        test_description = "Validate Nix expression syntax and formatting",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        result_link = "result-debug",
        setup_description = "Verify Nix CLI (debug)",
        compile_description = "Check Nix expressions with verbose output (debug)",
        bundle_description = "Verify Nix debug build artifacts",
        test_description = "Validate Nix expressions (verbose)",
        test_args = "--show-trace",
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
