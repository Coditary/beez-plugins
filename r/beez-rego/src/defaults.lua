local M = {}

M.runnable = true

M.build_dir = "build/rego"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.rego_binary = "opa"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[rego-setup]"
M.log_prefix_compile = "[rego-compile]"
M.log_prefix_bundle = "[rego-bundle]"
M.log_prefix_test = "[rego-test]"
M.log_prefix_run = "[rego-run]"

M.common_inputs = {
    "**/*.rego"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "true",
        run_prefix = "",
        run_tokens = {"eval", "-d"},
        setup_description = "Verify Rego runtime and prepare build directory",
        compile_description = "Validate Rego entry with opa",
        bundle_description = "Verify Rego compile stamp",
        test_description = "Run primary Rego entry",
        test_args = "",
        run_description = "Run Rego application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "true",
        run_prefix = "",
        run_tokens = {"eval", "-d"},
        setup_description = "Verify Rego runtime (debug)",
        compile_description = "Validate Rego entry with opa (debug)",
        bundle_description = "Verify Rego debug compile stamp",
        test_description = "Run primary Rego entry (verbose)",
        test_args = "",
        run_description = "Run Rego application (debug)",
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
