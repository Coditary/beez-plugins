local M = {}

M.runnable = true

M.build_dir = "build/elua"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.scons_binary = "scons"
M.cross_gcc_binary = "arm-none-eabi-gcc"
M.lua_binary = "lua"
M.elua_build_subdir = "0.9"
M.default_platform = "linux"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[elua-setup]"
M.log_prefix_compile = "[elua-compile]"
M.log_prefix_bundle = "[elua-bundle]"
M.log_prefix_test = "[elua-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "SConstruct",
    "platform_data.lua",
    "src/**/*.lua",
}

M.build_profiles = {
    code = {
        scope = "elua",
        output_name = "firmware",
        scons_extra_args = "",
        setup_description = "Verify scons/arm-none-eabi-gcc and prepare eLua build directory",
        compile_description = "Build eLua firmware with scons for embedded target",
        bundle_description = "Verify eLua firmware artifacts in build/elua/",
        test_description = "Validate application Lua scripts load on host",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "elua",
        output_name = "firmware",
        scons_extra_args = "DEBUG=1",
        setup_description = "Verify scons/arm-none-eabi-gcc and prepare eLua build directory (debug)",
        compile_description = "Build eLua firmware with debug symbols (scons DEBUG=1)",
        bundle_description = "Verify eLua debug firmware artifacts",
        test_description = "Validate application Lua scripts with verbose host checks",
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
