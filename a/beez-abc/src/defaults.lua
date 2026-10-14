local M = {}

M.runnable = false

M.build_dir = "build/abc"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.abcm2ps_binary = "abcm2ps"
M.ps2pdf_binary = "ps2pdf"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[abc-setup]"
M.log_prefix_compile = "[abc-compile]"
M.log_prefix_bundle = "[abc-bundle]"
M.log_prefix_test = "[abc-test]"


M.common_inputs = {
    "**/*.abc",
}

M.build_profiles = {
    code = {
        scope = "abc",
        output_name = "app.pdf",
        setup_description = "Verify abcm2ps ABC notation compiler",
        compile_description = "Render ABC notation to PDF via abcm2ps",
        bundle_description = "Verify ABC build artifacts",
        test_description = "Validate ABC notation sources",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.ps",
        setup_description = "Verify abcm2ps compiler (debug)",
        compile_description = "Render ABC notation to PostScript (debug)",
        bundle_description = "Verify ABC debug artifacts",
        test_description = "Validate ABC notation sources (verbose)",
        compile_args = "-v",
        test_args = "-v",
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
