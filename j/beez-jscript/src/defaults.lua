local M = {}

M.runnable = true

M.build_dir = "build/jscript"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.wine_binary = "wine"
M.cscript_binary = "cscript.exe"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jscript-setup]"
M.log_prefix_compile = "[jscript-compile]"
M.log_prefix_bundle = "[jscript-bundle]"
M.log_prefix_test = "[jscript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.js",
    "**/*.jse",
}

M.build_profiles = {
    code = {
        scope = "jscript",
        output_name = "app.js",
        setup_description = "Verify Wine and cscript.exe for JScript",
        compile_description = "Syntax-check JScript sources via Wine cscript",
        bundle_description = "Verify JScript compile stamp",
        test_description = "Validate JScript script compilation",
        compile_args = "//Nologo //E:jscript //B",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jscript",
        output_name = "app.js",
        setup_description = "Verify Wine and cscript.exe for JScript (debug)",
        compile_description = "Syntax-check JScript sources via Wine cscript (verbose)",
        bundle_description = "Verify JScript debug compile stamp",
        test_description = "Validate JScript script compilation (verbose)",
        compile_args = "//Nologo //E:jscript //B //X",
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
