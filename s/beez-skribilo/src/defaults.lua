local M = {}

M.runnable = false

M.build_dir = "build/skribilo"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.skribilo_binary = "skribilo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[skribilo-setup]"
M.log_prefix_compile = "[skribilo-compile]"
M.log_prefix_bundle = "[skribilo-bundle]"
M.log_prefix_test = "[skribilo-test]"


M.common_inputs = {
    "**/*.skr",
    "**/*.ss",
}

M.build_profiles = {
    code = {
        scope = "skribilo",
        output_name = "app.pdf",
        setup_description = "Verify Skribilo Guile/Scheme document compiler",
        compile_description = "Compile Skribilo document to PDF",
        bundle_description = "Verify Skribilo build artifacts",
        test_description = "Validate Skribilo document sources",
        compile_args = "--target=pdf",
        test_args = "--version",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        setup_description = "Verify Skribilo compiler (debug)",
        compile_description = "Compile Skribilo document to PDF (debug)",
        bundle_description = "Verify Skribilo debug artifacts",
        test_description = "Validate Skribilo document sources (verbose)",
        compile_args = "--target=pdf --verbose",
        test_args = "--version",
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
