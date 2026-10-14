local M = {}

M.runnable = true

M.build_dir = "build/babashka"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.babashka_binary = "bb"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[babashka-setup]"
M.log_prefix_compile = "[babashka-compile]"
M.log_prefix_bundle = "[babashka-bundle]"
M.log_prefix_test = "[babashka-test]"
M.log_prefix_run = "[babashka-run]"

M.common_inputs = {
    "**/*.bb",
    "**/*.clj",
    "bb.edn",
    "**/bb.edn"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Babashka runtime and prepare build directory",
        compile_description = "Validate Babashka entry with bb",
        bundle_description = "Verify Babashka compile stamp",
        test_description = "Run primary Babashka entry",
        test_args = "",
        run_description = "Run Babashka application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Babashka runtime (debug)",
        compile_description = "Validate Babashka entry with bb (debug)",
        bundle_description = "Verify Babashka debug compile stamp",
        test_description = "Run primary Babashka entry (verbose)",
        test_args = "",
        run_description = "Run Babashka application (debug)",
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
