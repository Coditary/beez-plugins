local M = {}

M.runnable = true

M.build_dir = "build/erlc"
M.ebin_dir = M.build_dir .. "/ebin"
M.reports_dir = "report"

M.erlc_binary = "erlc"
M.rebar3_binary = "rebar3"
M.mix_binary = "mix"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[erlc-setup]"
M.log_prefix_compile = "[erlc-compile]"
M.log_prefix_bundle = "[erlc-bundle]"
M.log_prefix_test = "[erlc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "rebar.config",
    "rebar.config.script",
    "mix.exs",
    "rebar.lock",
    "src/**/*.erl",
    "src/**/*.hrl",
    "include/**/*.hrl",
    "lib/**/*.erl",
    "lib/**/*.hrl",
    "**/*.erl",
    "**/*.hrl",
}

M.build_profiles = {
    code = {
        scope = "erlang",
        build_mode = "release",
        output_name = "app",
        erlc_args = {},
        setup_description = "Resolve Erlang/OTP dependencies (rebar3, mix, or erlc)",
        compile_description = "Compile Erlang sources to BEAM bytecode",
        bundle_description = "Verify Erlang/OTP build artifacts",
        test_description = "Run Erlang/OTP tests",
        test_args = "",
        rebar3_compile_task = "compile",
        rebar3_test_task = "eunit",
        mix_compile_task = "compile",
        mix_test_task = "test",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        erlc_args = { "+debug_info" },
        setup_description = "Resolve Erlang/OTP dependencies (debug)",
        compile_description = "Compile Erlang sources to BEAM bytecode (debug)",
        bundle_description = "Verify Erlang/OTP debug artifacts",
        test_description = "Run Erlang/OTP tests (verbose)",
        test_args = "--verbose",
        rebar3_compile_task = "compile",
        rebar3_test_task = "eunit",
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
