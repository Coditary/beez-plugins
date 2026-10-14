local M = {}

M.runnable = true

M.build_dir = "build/hipe"
M.ebin_dir = M.build_dir .. "/ebin"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.erlc_binary = "erlc"
M.erl_binary = "erl"
M.rebar3_binary = "rebar3"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[hipe-setup]"
M.log_prefix_compile = "[hipe-compile]"
M.log_prefix_bundle = "[hipe-bundle]"
M.log_prefix_test = "[hipe-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "rebar.config",
    "rebar.config.script",
    "**/*.erl",
}

M.build_profiles = {
    code = {
        scope = "hipe",
        build_mode = "native",
        output_name = "app",
        erlc_opts = { "+native", "+'{hipe, [o3]}'" },
        setup_description = "Resolve Erlang dependencies and verify HiPE (+native) support",
        compile_description = "Compile Erlang sources with HiPE native code (+native)",
        bundle_description = "Verify HiPE native build artifacts",
        test_description = "Run Erlang tests (rebar3 eunit/ct or compile-only fallback)",
        test_args = "",
        rebar_compile_profile = "native",
    },

    debug = {
        scope = "debug",
        build_mode = "native-debug",
        output_name = "app",
        erlc_opts = { "+native", "+'{hipe, [o0]}'" },
        setup_description = "Resolve Erlang dependencies (HiPE debug native)",
        compile_description = "Compile Erlang sources with HiPE native code (debug, o0)",
        bundle_description = "Verify HiPE debug native artifacts",
        test_description = "Run Erlang tests (HiPE debug, verbose)",
        test_args = "-v",
        rebar_compile_profile = "native",
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
