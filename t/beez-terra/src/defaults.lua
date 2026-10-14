local M = {}

M.runnable = true

M.build_dir = "build/terra"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.terra_binary = "terra"
M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[terra-setup]"
M.log_prefix_compile = "[terra-compile]"
M.log_prefix_bundle = "[terra-bundle]"
M.log_prefix_test = "[terra-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.t",
    "**/*.lua",
}

M.build_profiles = {
    code = {
        scope = "terra",
        optimize = "2",
        output_name = "app",
        setup_description = "Verify Terra (LLVM embedded in Lua)",
        compile_description = "Compile Terra sources via terra JIT",
        bundle_description = "Verify Terra compile artifacts",
        test_description = "Run Terra/Lua tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "terra",
        optimize = "0",
        output_name = "app",
        setup_description = "Verify Terra compiler (debug)",
        compile_description = "Compile Terra sources with debug info (-g)",
        bundle_description = "Verify Terra debug compile artifacts",
        test_description = "Run Terra/Lua tests (verbose)",
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
