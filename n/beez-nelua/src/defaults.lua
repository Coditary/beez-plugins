local M = {}

M.runnable = true

M.build_dir = "build/nelua"
M.bin_dir = M.build_dir .. "/bin"
M.gen_dir = M.build_dir .. "/gen"
M.reports_dir = "report"

M.nelua_binary = "nelua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nelua-setup]"
M.log_prefix_compile = "[nelua-compile]"
M.log_prefix_bundle = "[nelua-bundle]"
M.log_prefix_test = "[nelua-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "project.nelua",
    "**/*.nelua",
}

M.build_profiles = {
    code = {
        scope = "nelua",
        compile_mode = "binary",
        output_name = "app",
        setup_description = "Verify Nelua compiler (nelua→C)",
        compile_description = "Compile Nelua to native binary via C backend",
        bundle_description = "Verify Nelua build artifacts",
        test_description = "Run Nelua tests or compiled binary",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "nelua",
        compile_mode = "c",
        output_name = "app",
        setup_description = "Verify Nelua compiler (debug, C generation)",
        compile_description = "Generate C from Nelua sources (--gen c)",
        bundle_description = "Verify Nelua generated C artifacts",
        test_description = "Run Nelua tests (verbose)",
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
