local M = {}

M.runnable = true

M.build_dir = "build/ceu"
M.bin_dir = M.build_dir .. "/bin"
M.gen_dir = M.build_dir .. "/gen"
M.reports_dir = "report"

M.ceu_binary = "ceu"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ceu-setup]"
M.log_prefix_compile = "[ceu-compile]"
M.log_prefix_bundle = "[ceu-bundle]"
M.log_prefix_test = "[ceu-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.ceu",
}

M.build_profiles = {
    code = {
        scope = "ceu",
        output_name = "app",
        compile_mode = "binary",
        setup_description = "Verify Céu compiler (ceu→C→native)",
        compile_description = "Compile Céu sources to native binary",
        bundle_description = "Verify Céu build artifacts",
        test_description = "Run Céu compile smoke test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "ceu",
        output_name = "app",
        compile_mode = "c",
        setup_description = "Verify Céu compiler (debug, C generation)",
        compile_description = "Generate C from Céu sources",
        bundle_description = "Verify Céu generated C artifacts",
        test_description = "Run Céu tests (verbose)",
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
