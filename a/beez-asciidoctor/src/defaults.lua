local M = {}

M.runnable = false

M.build_dir = "build/asciidoctor"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.asciidoctor_binary = "asciidoctor"
M.asciidoctor_pdf_binary = "asciidoctor-pdf"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[asciidoctor-setup]"
M.log_prefix_compile = "[asciidoctor-compile]"
M.log_prefix_bundle = "[asciidoctor-bundle]"
M.log_prefix_test = "[asciidoctor-test]"


M.common_inputs = {
    "**/*.adoc",
}

M.build_profiles = {
    code = {
        scope = "asciidoctor",
        output_name = "app.pdf",
        setup_description = "Verify Asciidoctor and asciidoctor-pdf",
        compile_description = "Render AsciiDoc to PDF via asciidoctor-pdf",
        bundle_description = "Verify Asciidoctor build artifacts",
        test_description = "Run Asciidoctor validation",
        compile_args = "",
        use_pdf = true,
    },

    debug = {
        scope = "debug",
        output_name = "app.html",
        setup_description = "Verify Asciidoctor (debug)",
        compile_description = "Render AsciiDoc to HTML (debug)",
        bundle_description = "Verify Asciidoctor debug artifacts",
        test_description = "Run Asciidoctor validation (verbose)",
        compile_args = "-v",
        use_pdf = false,
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
