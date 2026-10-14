local M = {}

M.runnable = true

M.build_dir = "build/crystal"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.crystal_binary = "crystal"
M.shards_binary = "shards"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[crystal-setup]"
M.log_prefix_compile = "[crystal-compile]"
M.log_prefix_bundle = "[crystal-bundle]"
M.log_prefix_test = "[crystal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "shard.yml",
    "**/shard.yml",
    "**/*.cr",
}

M.build_profiles = {
    code = {
        scope = "app",
        release = true,
        output_name = "app",
        setup_description = "Install Crystal dependencies with shards",
        compile_description = "Compile Crystal to native code (release)",
        bundle_description = "Verify Crystal build artifacts",
        test_description = "Run Crystal specs",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        release = false,
        output_name = "app",
        setup_description = "Install Crystal dependencies with shards (debug)",
        compile_description = "Compile Crystal to native code (debug)",
        bundle_description = "Verify Crystal debug artifacts",
        test_description = "Run Crystal specs (verbose)",
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
