local M = {}

M.runnable = false

M.build_dir = "build/satysfi"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.satysfi_binary = "satysfi"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[satysfi-setup]"
M.log_prefix_compile = "[satysfi-compile]"
M.log_prefix_bundle = "[satysfi-bundle]"
M.log_prefix_test = "[satysfi-test]"


M.common_inputs = {
    "**/*.saty",
    "**/*.satyg",
}

M.build_profiles = {
    code = {
        scope = "satysfi",
        output_name = "app.pdf",
        setup_description = "Verify SATySFi OCaml typesetting compiler",
        compile_description = "Compile SATySFi document to PDF",
        bundle_description = "Verify SATySFi build artifacts",
        test_description = "Validate SATySFi document sources",
        compile_args = "",
        test_args = "--version",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        setup_description = "Verify SATySFi compiler (debug)",
        compile_description = "Compile SATySFi document to PDF (debug)",
        bundle_description = "Verify SATySFi debug artifacts",
        test_description = "Validate SATySFi document sources (verbose)",
        compile_args = "--debug-show-bbox",
        test_args = "--version",
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
