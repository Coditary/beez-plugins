local M = {}

M.runnable = true

M.build_dir = "build/love2d"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.love2d_binary = "love"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[love2d-setup]"
M.log_prefix_compile = "[love2d-compile]"
M.log_prefix_bundle = "[love2d-bundle]"
M.log_prefix_test = "[love2d-test]"
M.log_prefix_run = "[love2d-run]"

M.common_inputs = {
    "**/*.love"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Love2D runtime and prepare build directory",
        compile_description = "Validate Love2D entry with love",
        bundle_description = "Verify Love2D compile stamp",
        test_description = "Run primary Love2D entry",
        test_args = "",
        run_description = "Run Love2D application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {},
        setup_description = "Verify Love2D runtime (debug)",
        compile_description = "Validate Love2D entry with love (debug)",
        bundle_description = "Verify Love2D debug compile stamp",
        test_description = "Run primary Love2D entry (verbose)",
        test_args = "",
        run_description = "Run Love2D application (debug)",
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
