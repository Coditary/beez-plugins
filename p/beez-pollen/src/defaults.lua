local M = {}

M.runnable = false

M.build_dir = "build/pollen"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.raco_binary = "raco"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pollen-setup]"
M.log_prefix_compile = "[pollen-compile]"
M.log_prefix_bundle = "[pollen-bundle]"
M.log_prefix_test = "[pollen-test]"


M.common_inputs = {
    "**/*.pmd",
    "pollen.rkt",
    "**/pollen.rkt",
}

M.build_profiles = {
    code = {
        scope = "pollen",
        output_name = "main",
        setup_description = "Verify Pollen Racket publishing toolchain",
        compile_description = "Render Pollen document to HTML/PDF",
        bundle_description = "Verify Pollen build output",
        test_description = "Render Pollen test documents",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify Pollen toolchain (debug)",
        compile_description = "Render Pollen document (debug)",
        bundle_description = "Verify Pollen debug output",
        test_description = "Render Pollen test documents (verbose)",
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
