local M = {}

M.runnable = true

M.build_dir = "build/idris"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.idris_binary = "idris"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[idris-setup]"
M.log_prefix_compile = "[idris-compile]"
M.log_prefix_bundle = "[idris-bundle]"
M.log_prefix_test = "[idris-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.idr",
}

M.build_profiles = {
    code = {
        scope = "idris",
        output_name = "app",
        optimize = "-O2",
        setup_description = "Verify Idris 1 toolchain and prepare build directories",
        compile_description = "Compile Idris 1 sources (idris)",
        bundle_description = "Verify Idris 1 build artifacts",
        test_description = "Run compiled Idris 1 binary or test suite",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "idris",
        output_name = "app",
        optimize = "-g",
        setup_description = "Verify Idris 1 toolchain (debug profile)",
        compile_description = "Compile Idris 1 sources with debug info",
        bundle_description = "Verify Idris 1 debug build artifacts",
        test_description = "Run Idris 1 tests (debug profile)",
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
