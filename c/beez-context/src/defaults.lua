local M = {}

M.runnable = false

M.build_dir = "build/context"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.context_binary = "context.mkiv"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[context-setup]"
M.log_prefix_compile = "[context-compile]"
M.log_prefix_bundle = "[context-bundle]"
M.log_prefix_test = "[context-test]"


M.common_inputs = {
    "**/*.tex",
    "context.mkiv",
    "**/context.mkiv",
}

M.build_profiles = {
    code = {
        scope = "context",
        output_name = "main",
        setup_description = "Verify ConTeXt LuaTeX compiler (context.mkiv)",
        compile_description = "Compile ConTeXt document to PDF",
        bundle_description = "Verify ConTeXt PDF output",
        test_description = "Compile ConTeXt test documents",
        compile_args = "--nonstopmode --batch",
        compile_passes = 1,
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify ConTeXt compiler (debug)",
        compile_description = "Compile ConTeXt document to PDF (debug)",
        bundle_description = "Verify ConTeXt debug PDF output",
        test_description = "Compile ConTeXt test documents (verbose)",
        compile_args = "--nonstopmode --file-line-error",
        compile_passes = 1,
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
