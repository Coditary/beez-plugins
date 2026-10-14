local M = {}

M.runnable = true

M.build_dir = "build/bosque"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.node_binary = "node"
M.bosque_binary = "bosque"
M.npm_binary = "npm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[bosque-setup]"
M.log_prefix_compile = "[bosque-compile]"
M.log_prefix_bundle = "[bosque-bundle]"
M.log_prefix_test = "[bosque-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "package.json",
    "**/package.json",
    "**/*.bsq",
}

M.build_profiles = {
    code = {
        scope = "bosque",
        output_name = "app",
        compile_mode = "exe",
        setup_description = "Verify Node.js and Bosque toolchain",
        compile_description = "Compile Bosque sources to native executable",
        bundle_description = "Verify Bosque build artifacts",
        test_description = "Run Bosque package tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "bosque",
        output_name = "app",
        compile_mode = "interpret",
        setup_description = "Verify Node.js and Bosque toolchain (debug)",
        compile_description = "Type-check Bosque sources with bosque test",
        bundle_description = "Verify Bosque debug artifacts",
        test_description = "Run Bosque tests (verbose)",
        test_args = "-v",
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
