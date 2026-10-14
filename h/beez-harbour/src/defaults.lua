local M = {}

M.runnable = true

M.build_dir = "build/harbour"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.harbour_binary = "harbour"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[harbour-setup]"
M.log_prefix_compile = "[harbour-compile]"
M.log_prefix_bundle = "[harbour-bundle]"
M.log_prefix_test = "[harbour-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.prg",
}

M.build_profiles = {
    code = {
        scope = "harbour",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify harbour and prepare build directory",
        compile_description = "Compile Harbour sources (harbour)",
        bundle_description = "Verify Harbour compile artifacts",
        test_description = "Verify Harbour build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "harbour",
        output_name = "app",
        compile_flag = "-g2",
        setup_description = "Verify harbour and prepare build directory (debug)",
        compile_description = "Compile Harbour sources with debug flags",
        bundle_description = "Verify Harbour debug compile artifacts",
        test_description = "Verify Harbour debug build output",
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
