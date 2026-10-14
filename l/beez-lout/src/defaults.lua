local M = {}

M.runnable = false

M.build_dir = "build/lout"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.lout_binary = "lout"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[lout-setup]"
M.log_prefix_compile = "[lout-compile]"
M.log_prefix_bundle = "[lout-bundle]"
M.log_prefix_test = "[lout-test]"


M.common_inputs = {
    "**/*.lt",
}

M.build_profiles = {
    code = {
        scope = "lout",
        output_name = "main",
        setup_description = "Verify Lout typesetting compiler",
        compile_description = "Compile Lout document to PDF",
        bundle_description = "Verify Lout PDF output",
        test_description = "Compile Lout test documents",
        compile_args = "-PDF",
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify Lout compiler (debug)",
        compile_description = "Compile Lout document to PDF (debug)",
        bundle_description = "Verify Lout debug PDF output",
        test_description = "Compile Lout test documents (verbose)",
        compile_args = "-PDF -dbg",
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
