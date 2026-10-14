local M = {}

M.runnable = true

M.build_dir = "build/jcl"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.jcl_binary = "jcl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jcl-setup]"
M.log_prefix_compile = "[jcl-compile]"
M.log_prefix_bundle = "[jcl-bundle]"
M.log_prefix_test = "[jcl-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.jcl",
}

M.build_profiles = {
    code = {
        scope = "jcl",
        output_name = "job",
        compile_flag = "",
        setup_description = "Verify JCL mainframe job processor and prepare build directory",
        compile_description = "Validate and package IBM JCL job streams (*.jcl)",
        bundle_description = "Verify JCL build artifacts",
        test_description = "Verify JCL build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jcl",
        output_name = "job",
        compile_flag = "-v",
        setup_description = "Verify JCL job processor and prepare build directory (debug)",
        compile_description = "Validate JCL job streams with verbose logging",
        bundle_description = "Verify JCL debug build artifacts",
        test_description = "Verify JCL debug build output",
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
