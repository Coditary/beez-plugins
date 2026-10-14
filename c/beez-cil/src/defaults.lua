local M = {}

M.runnable = true

M.build_dir = "build/cil"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ilasm_binary = "ilasm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cil-setup]"
M.log_prefix_compile = "[cil-compile]"
M.log_prefix_bundle = "[cil-bundle]"
M.log_prefix_test = "[cil-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.il",
}

M.build_profiles = {
    code = {
        scope = "cil",
        output_name = "app",
        output_kind = "exe",
        compile_flags = "",
        setup_description = "Verify .NET ilasm CIL assembler",
        compile_description = "Assemble CIL sources with ilasm",
        bundle_description = "Verify ilasm build artifacts",
        test_description = "Verify assembled CIL binaries",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "cil",
        output_name = "app",
        output_kind = "exe",
        compile_flags = "/DEBUG",
        setup_description = "Verify .NET ilasm CIL assembler (debug)",
        compile_description = "Assemble CIL sources with ilasm (debug)",
        bundle_description = "Verify ilasm debug artifacts",
        test_description = "Verify assembled CIL binaries (verbose)",
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
