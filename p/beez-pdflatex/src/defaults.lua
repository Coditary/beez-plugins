local M = {}

M.runnable = false

M.build_dir = "build/pdflatex"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.pdflatex_binary = "pdflatex"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pdflatex-setup]"
M.log_prefix_compile = "[pdflatex-compile]"
M.log_prefix_bundle = "[pdflatex-bundle]"
M.log_prefix_test = "[pdflatex-test]"


M.common_inputs = {
    "**/*.tex",
    "main.tex",
}

M.build_profiles = {
    code = {
        scope = "pdflatex",
        output_name = "main",
        setup_description = "Verify pdfLaTeX compiler (pdfTeX)",
        compile_description = "Compile LaTeX document to PDF via pdfLaTeX",
        bundle_description = "Verify pdfLaTeX PDF output",
        test_description = "Compile LaTeX test documents",
        compile_args = "-interaction=nonstopmode -halt-on-error",
        compile_passes = 2,
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify pdfLaTeX compiler (debug)",
        compile_description = "Compile LaTeX document to PDF via pdfLaTeX (debug)",
        bundle_description = "Verify pdfLaTeX debug PDF output",
        test_description = "Compile LaTeX test documents (verbose)",
        compile_args = "-interaction=nonstopmode -file-line-error",
        compile_passes = 2,
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
