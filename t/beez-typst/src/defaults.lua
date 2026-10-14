local M = {}

M.runnable = false

M.build_dir = "build/typst"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.typst_binary = "typst"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[typst-setup]"
M.log_prefix_compile = "[typst-compile]"
M.log_prefix_bundle = "[typst-bundle]"
M.log_prefix_test = "[typst-test]"


M.common_inputs = {
    "**/*.typ",
}

M.build_profiles = {
    code = {
        scope = "typst",
        output_name = "app.pdf",
        setup_description = "Verify Typst compiler",
        compile_description = "Compile Typst to PDF",
        bundle_description = "Verify Typst build artifacts",
        test_description = "Run Typst validation",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        setup_description = "Verify Typst compiler (debug)",
        compile_description = "Compile Typst to PDF (debug)",
        bundle_description = "Verify Typst debug artifacts",
        test_description = "Run Typst validation (verbose)",
        compile_args = "--diagnostic-format=short",
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
