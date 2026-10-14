local M = {}

M.runnable = true

M.build_dir = "build/beamasm"
M.ebin_dir = M.build_dir .. "/ebin"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.erlc_binary = "erlc"
M.erl_binary = "erl"
M.rebar3_binary = "rebar3"
M.mix_binary = "mix"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[beamasm-setup]"
M.log_prefix_compile = "[beamasm-compile]"
M.log_prefix_bundle = "[beamasm-bundle]"
M.log_prefix_test = "[beamasm-test]"

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
        scope = "beamasm",
        build_mode = "release",
        output_name = "app",
        erlc_args = {},
        erl_args = "+jit",
        setup_description = "Resolve Erlang/OTP dependencies and verify BEAM JIT (+jit) support",
        compile_description = "Compile Erlang sources to BEAM bytecode for JIT execution",
        bundle_description = "Verify BEAM JIT build artifacts and install erl +jit launcher",
        test_description = "Run Erlang/OTP tests with BEAM JIT enabled",
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
        erl_args = "+jit",
        setup_description = "Resolve Erlang/OTP dependencies and verify BEAM JIT (debug)",
        compile_description = "Compile Erlang sources to BEAM bytecode (debug, +debug_info)",
        bundle_description = "Verify BEAM JIT debug artifacts and install erl +jit launcher",
        test_description = "Run Erlang/OTP tests with BEAM JIT enabled (verbose)",
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
