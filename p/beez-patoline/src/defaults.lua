local M = {}

M.runnable = false

M.build_dir = "build/patoline"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.patoline_binary = "patoline"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[patoline-setup]"
M.log_prefix_compile = "[patoline-compile]"
M.log_prefix_bundle = "[patoline-bundle]"
M.log_prefix_test = "[patoline-test]"


M.common_inputs = {
    "**/*.tli",
}

M.build_profiles = {
    code = {
        scope = "patoline",
        output_name = "main",
        setup_description = "Verify Patoline OCaml typesetting compiler",
        compile_description = "Compile Patoline document to PDF",
        bundle_description = "Verify Patoline PDF output",
        test_description = "Compile Patoline test documents",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify Patoline compiler (debug)",
        compile_description = "Compile Patoline document to PDF (debug)",
        bundle_description = "Verify Patoline debug PDF output",
        test_description = "Compile Patoline test documents (verbose)",
        compile_args = "-verbose",
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
