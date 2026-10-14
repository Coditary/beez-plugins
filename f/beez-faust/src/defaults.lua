local M = {}

M.runnable = true

M.build_dir = "build/faust"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.faust_binary = "faust"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[faust-setup]"
M.log_prefix_compile = "[faust-compile]"
M.log_prefix_bundle = "[faust-bundle]"
M.log_prefix_test = "[faust-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.dsp",
}

M.build_profiles = {
    code = {
        scope = "faust",
        output_name = "app.cpp",
        output_lang = "cpp",
        setup_description = "Verify Faust compiler binary",
        compile_description = "Compile Faust DSP to C++",
        bundle_description = "Verify Faust build artifacts",
        test_description = "Validate Faust DSP compilation",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app.cpp",
        output_lang = "cpp",
        setup_description = "Verify Faust compiler binary (debug)",
        compile_description = "Compile Faust DSP to C++ (debug)",
        bundle_description = "Verify Faust debug artifacts",
        test_description = "Validate Faust DSP compilation (verbose)",
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
