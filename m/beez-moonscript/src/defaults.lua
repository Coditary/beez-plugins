local M = {}

M.runnable = true

M.build_dir = "build/moonscript"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.moonc_binary = "moonc"
M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[moonscript-setup]"
M.log_prefix_compile = "[moonscript-compile]"
M.log_prefix_bundle = "[moonscript-bundle]"
M.log_prefix_test = "[moonscript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.moon",
}

M.build_profiles = {
    code = {
        scope = "moonscript",
        output_name = "app",
        setup_description = "Verify moonc/lua and prepare build directory",
        compile_description = "Compile MoonScript sources to Lua (moonc)",
        bundle_description = "Verify compiled Lua artifacts",
        test_description = "Run compiled Lua with lua",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "moonscript",
        output_name = "app",
        setup_description = "Verify moonc/lua and prepare build directory (debug)",
        compile_description = "Compile MoonScript sources to Lua (moonc, debug)",
        bundle_description = "Verify compiled Lua debug artifacts",
        test_description = "Run compiled Lua with lua (verbose)",
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
