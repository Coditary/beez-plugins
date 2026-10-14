local M = {}

M.runnable = true

M.build_dir = "build/uhc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.uhc_binary = "uhc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[uhc-setup]"
M.log_prefix_compile = "[uhc-compile]"
M.log_prefix_bundle = "[uhc-bundle]"
M.log_prefix_test = "[uhc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.hs",
    "*.uhi",
}

M.build_profiles = {
    code = {
        scope = "uhc",
        build_mode = "release",
        output_name = "app",
        uhc_flags = "-O,2",
        setup_description = "Verify UHC compiler and prepare build directories",
        compile_description = "Build with UHC (Utrecht Haskell Compiler, optimized)",
        bundle_description = "Verify UHC build artifacts",
        test_description = "Run Haskell tests with UHC",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "uhc",
        build_mode = "debug",
        output_name = "app",
        uhc_flags = "",
        setup_description = "Verify UHC compiler (debug profile)",
        compile_description = "Build with UHC (debug, no optimizations)",
        bundle_description = "Verify UHC debug artifacts",
        test_description = "Run Haskell tests with UHC (debug)",
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
