local M = {}

M.runnable = false

M.build_dir = "build/blockdiag"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.blockdiag_binary = "blockdiag"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[blockdiag-setup]"
M.log_prefix_compile = "[blockdiag-compile]"
M.log_prefix_bundle = "[blockdiag-bundle]"
M.log_prefix_test = "[blockdiag-test]"


M.common_inputs = {
    "**/*.diag",
    "**/*blockdiag*",
}

M.build_profiles = {
    code = {
        scope = "blockdiag",
        output_format = "png",
        output_name = "app.png",
        setup_description = "Verify blockdiag network topology renderer",
        compile_description = "Render blockdiag *.diag to PNG",
        bundle_description = "Verify blockdiag build artifacts",
        test_description = "Validate blockdiag diagram sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "svg",
        output_name = "app.svg",
        setup_description = "Verify blockdiag renderer (debug)",
        compile_description = "Render blockdiag *.diag to SVG (debug)",
        bundle_description = "Verify blockdiag debug artifacts",
        test_description = "Validate blockdiag sources (verbose)",
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
