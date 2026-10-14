local M = {}

M.runnable = false

M.build_dir = "build/prince"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.prince_binary = "prince"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[prince-setup]"
M.log_prefix_compile = "[prince-compile]"
M.log_prefix_bundle = "[prince-bundle]"
M.log_prefix_test = "[prince-test]"


M.common_inputs = {
    "**/*.html",
    "**/*.htm",
}

M.build_profiles = {
    code = {
        scope = "prince",
        output_name = "app.pdf",
        compile_args = "",
        setup_description = "Verify PrinceXML HTML-to-PDF converter",
        compile_description = "Render HTML+CSS to PDF via PrinceXML",
        bundle_description = "Verify PrinceXML build artifacts",
        test_description = "Validate HTML-to-PDF rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        compile_args = "--verbose",
        setup_description = "Verify PrinceXML converter (debug)",
        compile_description = "Render HTML+CSS to PDF with verbose logging",
        bundle_description = "Verify PrinceXML debug artifacts",
        test_description = "Validate HTML-to-PDF rendering (verbose)",
        test_args = "--verbose",
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
