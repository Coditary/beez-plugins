local M = {}

M.runnable = false

M.build_dir = "build/lualatex"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.lualatex_binary = "lualatex"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[lualatex-setup]"
M.log_prefix_compile = "[lualatex-compile]"
M.log_prefix_bundle = "[lualatex-bundle]"
M.log_prefix_test = "[lualatex-test]"


M.common_inputs = {
    "**/*.tex",
    "main.tex",
}

M.build_profiles = {
    code = {
        scope = "lualatex",
        output_name = "main",
        setup_description = "Verify LuaLaTeX compiler (LuaTeX)",
        compile_description = "Compile LaTeX document to PDF via LuaLaTeX",
        bundle_description = "Verify LuaLaTeX PDF output",
        test_description = "Compile LaTeX test documents",
        compile_args = "-interaction=nonstopmode -halt-on-error",
        compile_passes = 2,
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify LuaLaTeX compiler (debug)",
        compile_description = "Compile LaTeX document to PDF via LuaLaTeX (debug)",
        bundle_description = "Verify LuaLaTeX debug PDF output",
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
