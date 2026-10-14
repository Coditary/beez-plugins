local M = {}

M.runnable = false

M.build_dir = "build/speedata"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.sp_binary = "sp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[speedata-setup]"
M.log_prefix_compile = "[speedata-compile]"
M.log_prefix_bundle = "[speedata-bundle]"
M.log_prefix_test = "[speedata-test]"


M.common_inputs = {
    "**/*.xml",
    "layout.xml",
    "**/layout.xml",
}

M.build_profiles = {
    code = {
        scope = "speedata",
        output_name = "main",
        setup_description = "Verify Speedata Publisher (XML to PDF)",
        compile_description = "Publish XML document to PDF via Speedata",
        bundle_description = "Verify Speedata PDF output",
        test_description = "Publish Speedata test documents",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify Speedata Publisher (debug)",
        compile_description = "Publish XML document to PDF (debug)",
        bundle_description = "Verify Speedata debug PDF output",
        test_description = "Publish Speedata test documents (verbose)",
        compile_args = "--verbose",
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
