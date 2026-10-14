local M = {}

M.runnable = true

M.build_dir = "build/fennel"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.fennel_binary = "fennel"
M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fennel-setup]"
M.log_prefix_compile = "[fennel-compile]"
M.log_prefix_bundle = "[fennel-bundle]"
M.log_prefix_test = "[fennel-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.fnl",
}

M.build_profiles = {
    code = {
        scope = "fennel",
        correlate = false,
        output_name = "app",
        setup_description = "Verify fennel/lua and prepare build directory",
        compile_description = "Compile Fennel sources to Lua (fennel --compile)",
        bundle_description = "Verify compiled Lua artifacts",
        test_description = "Run compiled Lua output with lua",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "fennel",
        correlate = true,
        output_name = "app",
        setup_description = "Verify fennel/lua and prepare build directory (debug)",
        compile_description = "Compile Fennel sources to Lua with line correlation",
        bundle_description = "Verify compiled Lua debug artifacts",
        test_description = "Run compiled Lua output with lua (verbose)",
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
