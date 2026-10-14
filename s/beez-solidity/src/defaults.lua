local M = {}

M.runnable = true

M.build_dir = "build/solidity"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.solc_binary = "solc"
M.forge_binary = "forge"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[solidity-setup]"
M.log_prefix_compile = "[solidity-compile]"
M.log_prefix_bundle = "[solidity-bundle]"
M.log_prefix_test = "[solidity-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "foundry.toml",
    "**/foundry.toml",
    "**/*.sol",
}

M.compile_exclude = [[/(\.git|build|out|cache|node_modules)/]]

M.build_profiles = {
    code = {
        scope = "solidity",
        output_name = "app",
        setup_description = "Verify solc/forge and install Foundry dependencies",
        compile_description = "Compile Solidity contracts with solc or forge build",
        bundle_description = "Verify Solidity compile stamp",
        test_description = "Run Foundry/solc contract tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "solidity",
        output_name = "app",
        setup_description = "Verify solc/forge (debug)",
        compile_description = "Compile Solidity contracts (debug)",
        bundle_description = "Verify Solidity debug compile stamp",
        test_description = "Run contract tests (verbose)",
        test_args = "-vvv",
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
