local M = {}

M.runnable = false

M.build_dir = "build/pandoc"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.pandoc_binary = "pandoc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pandoc-setup]"
M.log_prefix_compile = "[pandoc-compile]"
M.log_prefix_bundle = "[pandoc-bundle]"
M.log_prefix_test = "[pandoc-test]"


M.common_inputs = {
    "**/*.md",
    "**/*.rst",
    "pandoc.yaml",
}

M.build_profiles = {
    code = {
        scope = "pandoc",
        output_name = "app.html",
        setup_description = "Verify Pandoc transpiler",
        compile_description = "Transpile document with Pandoc",
        bundle_description = "Verify Pandoc build artifacts",
        test_description = "Run Pandoc validation",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.html",
        setup_description = "Verify Pandoc transpiler (debug)",
        compile_description = "Transpile document with Pandoc (verbose)",
        bundle_description = "Verify Pandoc debug artifacts",
        test_description = "Run Pandoc validation (verbose)",
        compile_args = "-v",
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


return M
