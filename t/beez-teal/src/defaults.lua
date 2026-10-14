local M = {}

M.runnable = true

M.build_dir = "build/teal"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.tl_binary = "tl"
M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[teal-setup]"
M.log_prefix_compile = "[teal-compile]"
M.log_prefix_bundle = "[teal-bundle]"
M.log_prefix_test = "[teal-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "tlconfig.lua",
    "**/*.tl",
}

M.build_profiles = {
    code = {
        scope = "teal",
        check_only = false,
        output_name = "app",
        setup_description = "Verify Teal compiler (tl→Lua)",
        compile_description = "Compile Teal sources to Lua (tl build / tl gen)",
        bundle_description = "Verify generated Lua artifacts",
        test_description = "Run generated Lua output with lua",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "teal",
        check_only = true,
        output_name = "app",
        setup_description = "Verify Teal compiler (type-check only)",
        compile_description = "Type-check Teal sources (tl check)",
        bundle_description = "Verify Teal check report artifacts",
        test_description = "Run generated Lua output with lua (verbose)",
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
