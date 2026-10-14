local M = {}

M.runnable = false

M.build_dir = "build/asymptote"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.asy_binary = "asy"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[asymptote-setup]"
M.log_prefix_compile = "[asymptote-compile]"
M.log_prefix_bundle = "[asymptote-bundle]"
M.log_prefix_test = "[asymptote-test]"


M.common_inputs = {
    "**/*.asy",
}

M.build_profiles = {
    code = {
        scope = "asymptote",
        output_format = "png",
        output_name = "app.png",
        setup_description = "Verify Asymptote vector graphics compiler",
        compile_description = "Render Asymptote sources to PNG via asy",
        bundle_description = "Verify Asymptote build artifacts",
        test_description = "Validate Asymptote vector graphics rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "svg",
        output_name = "app.svg",
        setup_description = "Verify Asymptote compiler (debug)",
        compile_description = "Render Asymptote sources to SVG via asy",
        bundle_description = "Verify Asymptote debug artifacts",
        test_description = "Validate Asymptote rendering (verbose)",
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
