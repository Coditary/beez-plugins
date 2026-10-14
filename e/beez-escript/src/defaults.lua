local M = {}

M.runnable = true

M.build_dir = "build/escript"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.escript_binary = "escript"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[escript-setup]"
M.log_prefix_compile = "[escript-compile]"
M.log_prefix_bundle = "[escript-bundle]"
M.log_prefix_test = "[escript-test]"
M.log_prefix_run = "[escript-run]"

M.common_inputs = {
    "**/*.erl",
    "rebar.config",
    "**/rebar.config",
    "rebar.config.script",
    "**/rebar.config.script"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Escript runtime and prepare build directory",
        compile_description = "Validate Escript entry with escript",
        bundle_description = "Verify Escript compile stamp",
        test_description = "Run primary Escript entry",
        test_args = "",
        run_description = "Run Escript application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Escript runtime (debug)",
        compile_description = "Validate Escript entry with escript (debug)",
        bundle_description = "Verify Escript debug compile stamp",
        test_description = "Run primary Escript entry (verbose)",
        test_args = "",
        run_description = "Run Escript application (debug)",
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
