local M = {}

M.runnable = false

M.build_dir = "build/tikz"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.pdflatex_binary = "pdflatex"
M.lualatex_binary = "lualatex"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tikz-setup]"
M.log_prefix_compile = "[tikz-compile]"
M.log_prefix_bundle = "[tikz-bundle]"
M.log_prefix_test = "[tikz-test]"


M.common_inputs = {
    "**/*.tikz",
}

M.build_profiles = {
    code = {
        scope = "tikz",
        latex_engine = "pdflatex",
        output_name = "app.pdf",
        setup_description = "Verify pdflatex for TikZ/PGF standalone",
        compile_description = "Compile standalone TikZ to PDF via pdflatex",
        bundle_description = "Verify TikZ build artifacts",
        test_description = "Validate TikZ/PGF standalone rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        latex_engine = "lualatex",
        output_name = "app.pdf",
        setup_description = "Verify lualatex for TikZ/PGF standalone (debug)",
        compile_description = "Compile standalone TikZ to PDF via lualatex",
        bundle_description = "Verify TikZ debug artifacts",
        test_description = "Validate TikZ rendering (verbose)",
        test_args = "-interaction=nonstopmode",
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
