local M = {}

M.runnable = true

M.build_dir = "build/nim"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.nim_binary = "nim"
M.nimble_binary = "nimble"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nim-setup]"
M.log_prefix_compile = "[nim-compile]"
M.log_prefix_bundle = "[nim-bundle]"
M.log_prefix_test = "[nim-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.nimble",
    "**/*.nimble",
    "**/*.nim",
}

M.build_profiles = {
    code = {
        scope = "app",
        build_mode = "release",
        output_name = "app",
        defines = { "release" },
        setup_description = "Install Nim dependencies with nimble",
        compile_description = "Compile Nim to C and link (release)",
        bundle_description = "Verify Nim build artifacts",
        test_description = "Run Nim tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        defines = { "debug" },
        nim_flags = { "--opt:none", "--linedirs:on" },
        setup_description = "Install Nim dependencies with nimble (debug)",
        compile_description = "Compile Nim to C and link (debug)",
        bundle_description = "Verify Nim debug artifacts",
        test_description = "Run Nim tests (verbose)",
        test_args = "--verbose",
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
