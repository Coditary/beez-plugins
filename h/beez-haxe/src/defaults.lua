local M = {}

M.runnable = true

M.build_dir = "build/haxe"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.haxe_binary = "haxe"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[haxe-setup]"
M.log_prefix_compile = "[haxe-compile]"
M.log_prefix_bundle = "[haxe-bundle]"
M.log_prefix_test = "[haxe-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.hx",
    "project.xml",
    "**/project.xml",
    "build.hxml",
    "**/build.hxml",
    "haxelib.json",
    "**/haxelib.json",
}

M.build_profiles = {
    code = {
        scope = "haxe",
        output_name = "app",
        setup_description = "Verify haxe and prepare build directory",
        compile_description = "Compile Haxe sources with haxe",
        bundle_description = "Verify Haxe compile artifacts",
        test_description = "Run Haxe tests in t/ with prove",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "haxe",
        output_name = "app",
        setup_description = "Verify haxe and prepare build directory (debug)",
        compile_description = "Compile Haxe sources with haxe (debug)",
        bundle_description = "Verify Haxe debug compile artifacts",
        test_description = "Run Haxe tests in t/ with prove (verbose)",
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
