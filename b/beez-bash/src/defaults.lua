local M = {}

M.runnable = true

M.build_dir = "build/bash"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.bash_binary = "bash"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bash-setup]"
M.log_prefix_compile = "[bash-compile]"
M.log_prefix_bundle = "[bash-bundle]"
M.log_prefix_test = "[bash-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.sh",
    "**/*.bash",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "bash",
        output_name = "app",
        setup_description = "Verify bash and prepare build directory",
        compile_description = "Syntax-check bash scripts with bash -n",
        bundle_description = "Verify bash compile stamp",
        test_description = "Run primary bash script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "bash",
        output_name = "app",
        setup_description = "Verify bash and prepare build directory (debug)",
        compile_description = "Syntax-check bash scripts with bash -n (debug)",
        bundle_description = "Verify bash debug compile stamp",
        test_description = "Run primary bash script (verbose)",
        test_args = "-x",
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
