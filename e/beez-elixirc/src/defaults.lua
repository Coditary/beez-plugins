local M = {}

M.runnable = true

M.build_dir = "build/elixirc"
M.ebin_dir = M.build_dir .. "/ebin"
M.reports_dir = "report"

M.mix_binary = "mix"
M.elixirc_binary = "elixirc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[elixirc-setup]"
M.log_prefix_compile = "[elixirc-compile]"
M.log_prefix_bundle = "[elixirc-bundle]"
M.log_prefix_test = "[elixirc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "mix.exs",
    "mix.lock",
    "lib/**/*.ex",
    "lib/**/*.exs",
    "src/**/*.ex",
    "src/**/*.exs",
    "test/**/*.ex",
    "test/**/*.exs",
    "**/*.ex",
    "**/*.exs",
}

M.build_profiles = {
    code = {
        scope = "elixir",
        build_mode = "release",
        mix_env = "prod",
        elixirc_args = {},
        setup_description = "Resolve Elixir dependencies (mix deps.get)",
        compile_description = "Compile Elixir sources to BEAM bytecode",
        bundle_description = "Verify Elixir build artifacts",
        test_description = "Run Elixir tests (mix test)",
        test_args = "",
        mix_compile_task = "compile",
        mix_test_task = "test",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        mix_env = "dev",
        elixirc_args = { "--debug-info" },
        setup_description = "Resolve Elixir dependencies (debug)",
        compile_description = "Compile Elixir sources to BEAM bytecode (debug)",
        bundle_description = "Verify Elixir debug artifacts",
        test_description = "Run Elixir tests (verbose)",
        test_args = "--trace",
        mix_compile_task = "compile",
        mix_test_task = "test",
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
