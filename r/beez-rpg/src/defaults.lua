local M = {}

M.runnable = true

M.build_dir = "build/rpg"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.rpg_binary = "crtbndrpg"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[rpg-setup]"
M.log_prefix_compile = "[rpg-compile]"
M.log_prefix_bundle = "[rpg-bundle]"
M.log_prefix_test = "[rpg-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.rpgle",
    "**/*.sqlrpgle",
}

M.compile_exclude = [[/(\.git|build|QSYS)/]]

M.build_profiles = {
    code = {
        scope = "rpg",
        output_name = "app",
        setup_description = "Verify IBM ILE RPG compiler (crtbndrpg)",
        compile_description = "Compile RPG sources with CRTBNDRPG",
        bundle_description = "Verify RPG compile stamp",
        test_description = "Run RPG unit tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "rpg",
        output_name = "app",
        setup_description = "Verify IBM ILE RPG compiler (debug)",
        compile_description = "Compile RPG sources with CRTBNDRPG (debug)",
        bundle_description = "Verify RPG debug compile stamp",
        test_description = "Run RPG unit tests (verbose)",
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
