local M = {}

M.runnable = true

M.build_dir = "build/luajit"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.luajit_binary = "luajit"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[luajit-setup]"
M.log_prefix_compile = "[luajit-compile]"
M.log_prefix_bundle = "[luajit-bundle]"
M.log_prefix_test = "[luajit-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.lua",
}

M.build_profiles = {
    code = {
        scope = "luajit",
        compile_mode = "bytecode",
        strip_debug = true,
        output_name = "app",
        setup_description = "Verify luajit and prepare build directory",
        compile_description = "Compile Lua sources to bytecode (luajit -b)",
        bundle_description = "Verify LuaJIT bytecode artifacts",
        test_description = "Run compiled bytecode with luajit",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "luajit",
        compile_mode = "run",
        strip_debug = false,
        output_name = "app",
        setup_description = "Verify luajit and prepare build directory (debug)",
        compile_description = "Validate Lua sources with direct luajit run",
        bundle_description = "Verify LuaJIT direct-run validation artifacts",
        test_description = "Run Lua sources with luajit (verbose)",
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
