local M = {}

M.runnable = false

M.build_dir = "build/docbook"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.xsltproc_binary = "xsltproc"
M.fop_binary = "fop"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.default_stylesheet = "/usr/share/sgml/docbook/xsl-stylesheets/xhtml/docbook.xsl"
M.default_fo_stylesheet = "/usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl"

M.log_prefix_setup = "[docbook-setup]"
M.log_prefix_compile = "[docbook-compile]"
M.log_prefix_bundle = "[docbook-bundle]"
M.log_prefix_test = "[docbook-test]"


M.common_inputs = {
    "**/*.xml",
}

M.build_profiles = {
    code = {
        scope = "docbook",
        output_name = "app.html",
        setup_description = "Verify xsltproc and FOP for DocBook",
        compile_description = "Transform DocBook XML to HTML via xsltproc",
        bundle_description = "Verify DocBook HTML build artifacts",
        test_description = "Validate DocBook XML with xmllint",
        output_format = "html",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        setup_description = "Verify xsltproc and FOP for DocBook (debug)",
        compile_description = "Transform DocBook XML to PDF via xsltproc and FOP",
        bundle_description = "Verify DocBook PDF build artifacts",
        test_description = "Validate DocBook XML with xmllint (verbose)",
        output_format = "pdf",
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
