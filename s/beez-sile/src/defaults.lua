local M = {}

M.runnable = false

M.build_dir = "build/sile"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.sile_binary = "sile"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sile-setup]"
M.log_prefix_compile = "[sile-compile]"
M.log_prefix_bundle = "[sile-bundle]"
M.log_prefix_test = "[sile-test]"


M.common_inputs = {
    "**/*.sil",
}

M.build_profiles = {
    code = {
        scope = "sile",
        output_name = "app.pdf",
        setup_description = "Verify SILE typesetter (HarfBuzz)",
        compile_description = "Typeset SILE document to PDF",
        bundle_description = "Verify SILE build artifacts",
        test_description = "Run SILE validation",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        setup_description = "Verify SILE typesetter (debug)",
        compile_description = "Typeset SILE document to PDF (debug)",
        bundle_description = "Verify SILE debug artifacts",
        test_description = "Run SILE validation (verbose)",
        compile_args = "-d",
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
