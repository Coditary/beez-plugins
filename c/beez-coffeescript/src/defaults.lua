local M = {}

M.runnable = true

M.build_dir = "build/coffeescript"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.coffeescript_binary = "coffee"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[coffeescript-setup]"
M.log_prefix_compile = "[coffeescript-compile]"
M.log_prefix_bundle = "[coffeescript-bundle]"
M.log_prefix_test = "[coffeescript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.coffee",
}

M.build_profiles = {
    code = {
        scope = "coffeescript",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify coffee and prepare build directory",
        compile_description = "Compile CoffeeScript sources (coffee)",
        bundle_description = "Verify CoffeeScript compile artifacts",
        test_description = "Verify CoffeeScript build output",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "coffeescript",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify coffee and prepare build directory (debug)",
        compile_description = "Compile CoffeeScript sources with debug flags",
        bundle_description = "Verify CoffeeScript debug compile artifacts",
        test_description = "Verify CoffeeScript debug build output",
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
