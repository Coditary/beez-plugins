local M = {}

M.runnable = true

M.build_dir = "build/mojo"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mojo_binary = "mojo"
M.magic_binary = "magic"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mojo-setup]"
M.log_prefix_compile = "[mojo-compile]"
M.log_prefix_bundle = "[mojo-bundle]"
M.log_prefix_test = "[mojo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "mojoproject.toml",
    "**/mojoproject.toml",
    "**/*.mojo",
    "**/*.🔥",
}

M.build_profiles = {
    code = {
        scope = "mojo",
        build_mode = "release",
        output_name = "app",
        optimization_level = "3",
        debug_level = "none",
        setup_description = "Install Mojo dependencies with magic",
        compile_description = "Compile Mojo to LLVM AOT binary (release)",
        bundle_description = "Verify Mojo build artifacts",
        test_description = "Run Mojo tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        optimization_level = "0",
        debug_level = "full",
        setup_description = "Install Mojo dependencies with magic (debug)",
        compile_description = "Compile Mojo to LLVM AOT binary (debug)",
        bundle_description = "Verify Mojo debug artifacts",
        test_description = "Run Mojo tests (verbose)",
        test_args = "--verbose",
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
