local M = {}

M.runnable = true

M.build_dir = "build/luac"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.luac_binary = "luac"
M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[luac-setup]"
M.log_prefix_compile = "[luac-compile]"
M.log_prefix_bundle = "[luac-bundle]"
M.log_prefix_test = "[luac-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.lua",
}

M.build_profiles = {
    code = {
        scope = "luac",
        strip_debug = true,
        output_name = "app",
        setup_description = "Verify luac/lua and prepare build directory",
        compile_description = "Compile Lua sources to bytecode (luac -o)",
        bundle_description = "Verify Lua bytecode artifacts",
        test_description = "Run compiled bytecode with lua",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "luac",
        strip_debug = false,
        output_name = "app",
        setup_description = "Verify luac/lua and prepare build directory (debug)",
        compile_description = "Compile Lua sources to bytecode with debug info",
        bundle_description = "Verify Lua debug bytecode artifacts",
        test_description = "Run compiled bytecode with lua (verbose)",
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
