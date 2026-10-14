local M = {}

M.runnable = true

M.build_dir = "build/lua"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[lua-setup]"
M.log_prefix_compile = "[lua-compile]"
M.log_prefix_bundle = "[lua-bundle]"
M.log_prefix_test = "[lua-test]"
M.log_prefix_run = "[lua-run]"

M.common_inputs = {
    "**/*.lua"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Lua runtime and prepare build directory",
        compile_description = "Validate Lua entry with lua",
        bundle_description = "Verify Lua compile stamp",
        test_description = "Run primary Lua entry",
        test_args = "",
        run_description = "Run Lua application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        setup_description = "Verify Lua runtime (debug)",
        compile_description = "Validate Lua entry with lua (debug)",
        bundle_description = "Verify Lua debug compile stamp",
        test_description = "Run primary Lua entry (verbose)",
        test_args = "",
        run_description = "Run Lua application (debug)",
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
