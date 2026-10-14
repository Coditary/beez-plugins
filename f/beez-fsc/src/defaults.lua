local M = {}

M.runnable = true

M.build_dir = "build/fsc"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.fsc_binary = "fsc"
M.dotnet_binary = "dotnet"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fsc-setup]"
M.log_prefix_compile = "[fsc-compile]"
M.log_prefix_bundle = "[fsc-bundle]"
M.log_prefix_test = "[fsc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.fs",
    "*.fsproj",
    "**/*.fsproj",
}

M.build_profiles = {
    code = {
        scope = "fsharp",
        output_name = "app",
        setup_description = "Verify fsc and prepare build directory",
        compile_description = "Compile F# sources with fsc",
        bundle_description = "Verify F# compile artifacts",
        test_description = "Run F# tests in t/ with prove",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "fsharp",
        output_name = "app",
        setup_description = "Verify fsc and prepare build directory (debug)",
        compile_description = "Compile F# sources with fsc (debug)",
        bundle_description = "Verify F# debug compile artifacts",
        test_description = "Run F# tests in t/ with prove (verbose)",
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
