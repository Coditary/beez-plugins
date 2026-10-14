local M = {}

M.runnable = true

M.build_dir = "build/bun"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.bun_binary = "bun"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[bun-setup]"
M.log_prefix_compile = "[bun-compile]"
M.log_prefix_bundle = "[bun-bundle]"
M.log_prefix_test = "[bun-test]"
M.log_prefix_run = "[bun-run]"

M.common_inputs = {
    "**/*.ts",
    "**/*.js",
    "**/*.mts",
    "**/*.mjs",
    "package.json",
    "**/package.json",
    "bunfig.toml",
    "**/bunfig.toml"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "run",
        setup_description = "Verify Bun runtime and prepare build directory",
        compile_description = "Validate Bun entry with bun",
        bundle_description = "Verify Bun compile stamp",
        test_description = "Run primary Bun entry",
        test_args = "",
        run_description = "Run Bun application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "run",
        setup_description = "Verify Bun runtime (debug)",
        compile_description = "Validate Bun entry with bun (debug)",
        bundle_description = "Verify Bun debug compile stamp",
        test_description = "Run primary Bun entry (verbose)",
        test_args = "",
        run_description = "Run Bun application (debug)",
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
