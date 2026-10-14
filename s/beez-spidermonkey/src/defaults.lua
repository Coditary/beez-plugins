local M = {}

M.runnable = true

M.build_dir = "build/spidermonkey"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.js_binary = "js"
M.mozjs_binary = "mozjs"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[spidermonkey-setup]"
M.log_prefix_compile = "[spidermonkey-compile]"
M.log_prefix_bundle = "[spidermonkey-bundle]"
M.log_prefix_test = "[spidermonkey-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.js",
}

M.build_profiles = {
    code = {
        scope = "spidermonkey",
        compile_mode = "compile",
        output_name = "app",
        setup_description = "Verify SpiderMonkey js/mozjs and prepare build directory",
        compile_description = "Compile JavaScript with SpiderMonkey (js -c, release)",
        bundle_description = "Verify SpiderMonkey compiled artifacts",
        test_description = "Run JavaScript with SpiderMonkey",
        js_args = "",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "spidermonkey",
        compile_mode = "run",
        output_name = "app",
        setup_description = "Verify SpiderMonkey js/mozjs and prepare build directory (debug)",
        compile_description = "Validate JavaScript with direct SpiderMonkey run",
        bundle_description = "Verify SpiderMonkey validation artifacts",
        test_description = "Run JavaScript with SpiderMonkey (verbose)",
        js_args = "-v",
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
