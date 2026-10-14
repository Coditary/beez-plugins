local M = {}

M.runnable = false

M.build_dir = "build/groff"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.groff_binary = "groff"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[groff-setup]"
M.log_prefix_compile = "[groff-compile]"
M.log_prefix_bundle = "[groff-bundle]"
M.log_prefix_test = "[groff-test]"


M.common_inputs = {
    "**/*.ms",
    "**/*.man",
    "**/*.roff",
}

M.build_profiles = {
    code = {
        scope = "groff",
        output_format = "pdf",
        output_name = "app.pdf",
        setup_description = "Verify groff/troff formatter",
        compile_description = "Format troff/man pages to PDF",
        bundle_description = "Verify groff build artifacts",
        test_description = "Validate groff source formatting",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "ps",
        output_name = "app.ps",
        setup_description = "Verify groff/troff formatter (debug)",
        compile_description = "Format troff/man pages to PostScript",
        bundle_description = "Verify groff debug artifacts",
        test_description = "Validate groff source formatting (verbose)",
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
