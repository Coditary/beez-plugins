local M = {}

M.runnable = true

M.build_dir = "build/icon"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.iconx_binary = "iconx"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[icon-setup]"
M.log_prefix_compile = "[icon-compile]"
M.log_prefix_bundle = "[icon-bundle]"
M.log_prefix_test = "[icon-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.icn",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "icon",
        output_name = "app",
        setup_description = "Verify iconx and prepare build directory",
        compile_description = "Compile Icon sources with iconx -c",
        bundle_description = "Verify icon compile stamp",
        test_description = "Run primary Icon program with iconx",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "icon",
        output_name = "app",
        setup_description = "Verify iconx and prepare build directory (debug)",
        compile_description = "Compile Icon sources with iconx -c (debug)",
        bundle_description = "Verify icon debug compile stamp",
        test_description = "Run primary Icon program with iconx (debug)",
        test_args = "-t",
        run_description = "Run application (debug)",
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
