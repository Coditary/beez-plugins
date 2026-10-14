local M = {}

M.runnable = true

M.build_dir = "build/luau"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.luau_binary = "luau"
M.luau_analyze_binary = "luau-analyze"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[luau-setup]"
M.log_prefix_compile = "[luau-compile]"
M.log_prefix_bundle = "[luau-bundle]"
M.log_prefix_test = "[luau-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.luau",
    "**/*.lua",
    "default.project.json",
    "**/default.project.json",
}

M.build_profiles = {
    code = {
        scope = "luau",
        optimize_level = "2",
        debug_level = "0",
        output_name = "app",
        setup_description = "Verify luau/luau-analyze and prepare build directory",
        compile_description = "Compile Luau sources to bytecode (luau --binary)",
        bundle_description = "Verify Luau bytecode artifacts",
        test_description = "Typecheck Luau sources with luau-analyze",
        analyze_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "luau",
        optimize_level = "0",
        debug_level = "2",
        output_name = "app",
        setup_description = "Verify luau/luau-analyze and prepare build directory (debug)",
        compile_description = "Compile Luau sources to bytecode with debug info",
        bundle_description = "Verify Luau debug bytecode artifacts",
        test_description = "Typecheck Luau sources with luau-analyze (verbose)",
        analyze_args = "--formatter=gnu",
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
