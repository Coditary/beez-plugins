local M = {}

M.runnable = true

M.build_dir = "build/pallene"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.pallenec_binary = "pallenec"
M.lua_binary = "lua"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pallene-setup]"
M.log_prefix_compile = "[pallene-compile]"
M.log_prefix_bundle = "[pallene-bundle]"
M.log_prefix_test = "[pallene-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.pln",
}

M.build_profiles = {
    code = {
        scope = "pallene",
        keep_c = false,
        output_name = "app",
        setup_description = "Verify Pallene compiler (pallenec→C)",
        compile_description = "Compile Pallene to Lua C extension (.so)",
        bundle_description = "Verify Pallene module artifacts",
        test_description = "Load compiled Pallene module with lua",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "pallene",
        keep_c = true,
        output_name = "app",
        setup_description = "Verify Pallene compiler (debug, keep C)",
        compile_description = "Compile Pallene with --keep-c for inspection",
        bundle_description = "Verify Pallene debug module artifacts",
        test_description = "Load compiled Pallene module with lua (verbose)",
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
