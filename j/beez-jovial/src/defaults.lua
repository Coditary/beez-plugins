local M = {}

M.runnable = true

M.build_dir = "build/jovial"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.jovial_binary = "jovial"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jovial-setup]"
M.log_prefix_compile = "[jovial-compile]"
M.log_prefix_bundle = "[jovial-bundle]"
M.log_prefix_test = "[jovial-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.jov",
}

M.build_profiles = {
    code = {
        scope = "jovial",
        output_name = "app",
        setup_description = "Verify jovial binary and prepare build directory",
        compile_description = "Compile JOVIAL .jov sources to object files",
        bundle_description = "Verify JOVIAL object file artifacts",
        test_description = "Verify JOVIAL build outputs exist",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jovial",
        output_name = "app",
        setup_description = "Verify jovial binary and prepare build directory (debug)",
        compile_description = "Compile JOVIAL .jov sources to object files (debug)",
        bundle_description = "Verify JOVIAL object file artifacts (debug)",
        test_description = "Verify JOVIAL build outputs exist (verbose)",
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
