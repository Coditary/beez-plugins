local M = {}

M.runnable = true

M.build_dir = "build/elixir"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.elixir_binary = "elixir"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[elixir-setup]"
M.log_prefix_compile = "[elixir-compile]"
M.log_prefix_bundle = "[elixir-bundle]"
M.log_prefix_test = "[elixir-test]"
M.log_prefix_run = "[elixir-run]"

M.common_inputs = {
    "**/*.exs",
    "mix.exs",
    "**/mix.exs"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Elixir runtime and prepare build directory",
        compile_description = "Validate Elixir entry with elixir",
        bundle_description = "Verify Elixir compile stamp",
        test_description = "Run primary Elixir entry",
        test_args = "",
        run_description = "Run Elixir application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Elixir runtime (debug)",
        compile_description = "Validate Elixir entry with elixir (debug)",
        bundle_description = "Verify Elixir debug compile stamp",
        test_description = "Run primary Elixir entry (verbose)",
        test_args = "",
        run_description = "Run Elixir application (debug)",
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
