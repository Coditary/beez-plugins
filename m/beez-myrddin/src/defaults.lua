local M = {}

M.runnable = true

M.build_dir = "build/myrddin"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mbld_binary = "mbld"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[myrddin-setup]"
M.log_prefix_compile = "[myrddin-compile]"
M.log_prefix_bundle = "[myrddin-bundle]"
M.log_prefix_test = "[myrddin-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Myrddin.build",
    "**/Myrddin.build",
    "bld.proj",
    "**/bld.proj",
    "**/*.myr",
}

M.build_profiles = {
    code = {
        scope = "myrddin",
        output_name = "app",
        setup_description = "Verify Myrddin mbld build tool",
        compile_description = "Compile Myrddin via mbld 6m codegen",
        bundle_description = "Verify Myrddin build artifacts",
        test_description = "Run Myrddin tests via mbld test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Myrddin mbld build tool (debug)",
        compile_description = "Compile Myrddin via mbld (debug)",
        bundle_description = "Verify Myrddin debug artifacts",
        test_description = "Run Myrddin tests (verbose)",
        test_args = "",
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
