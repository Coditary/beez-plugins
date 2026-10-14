local M = {}

M.runnable = false

M.build_dir = "build/seqdiag"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.seqdiag_binary = "seqdiag"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[seqdiag-setup]"
M.log_prefix_compile = "[seqdiag-compile]"
M.log_prefix_bundle = "[seqdiag-bundle]"
M.log_prefix_test = "[seqdiag-test]"


M.common_inputs = {
    "**/*.seqdiag",
    "**/*seqdiag*",
}

M.build_profiles = {
    code = {
        scope = "seqdiag",
        output_format = "png",
        output_name = "app.png",
        setup_description = "Verify seqdiag sequence diagram renderer",
        compile_description = "Render seqdiag *.seqdiag to PNG",
        bundle_description = "Verify seqdiag build artifacts",
        test_description = "Validate seqdiag sequence diagram sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "svg",
        output_name = "app.svg",
        setup_description = "Verify seqdiag renderer (debug)",
        compile_description = "Render seqdiag *.seqdiag to SVG (debug)",
        bundle_description = "Verify seqdiag debug artifacts",
        test_description = "Validate seqdiag sources (verbose)",
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
