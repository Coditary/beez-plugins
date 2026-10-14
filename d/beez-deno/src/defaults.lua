local M = {}

M.runnable = true

M.build_dir = "build/deno"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.deno_binary = "deno"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[deno-setup]"
M.log_prefix_compile = "[deno-compile]"
M.log_prefix_bundle = "[deno-bundle]"
M.log_prefix_test = "[deno-test]"
M.log_prefix_run = "[deno-run]"

M.common_inputs = {
    "**/*.ts",
    "**/*.js",
    "**/*.mts",
    "**/*.cts",
    "deno.json",
    "**/deno.json",
    "deno.jsonc",
    "**/deno.jsonc"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "--allow-all",
        run_prefix = "run",
        setup_description = "Verify Deno runtime and prepare build directory",
        compile_description = "Validate Deno entry with deno",
        bundle_description = "Verify Deno compile stamp",
        test_description = "Run primary Deno entry",
        test_args = "",
        run_description = "Run Deno application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "--allow-all",
        run_prefix = "run",
        setup_description = "Verify Deno runtime (debug)",
        compile_description = "Validate Deno entry with deno (debug)",
        bundle_description = "Verify Deno debug compile stamp",
        test_description = "Run primary Deno entry (verbose)",
        test_args = "",
        run_description = "Run Deno application (debug)",
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
