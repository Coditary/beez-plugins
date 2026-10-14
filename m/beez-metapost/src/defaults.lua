local M = {}

M.runnable = false

M.build_dir = "build/metapost"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mpost_binary = "mpost"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[metapost-setup]"
M.log_prefix_compile = "[metapost-compile]"
M.log_prefix_bundle = "[metapost-bundle]"
M.log_prefix_test = "[metapost-test]"


M.common_inputs = {
    "**/*.mp",
}

M.build_profiles = {
    code = {
        scope = "metapost",
        output_format = "pdf",
        output_name = "app.pdf",
        setup_description = "Verify MetaPost diagram compiler",
        compile_description = "Render MetaPost sources to PDF via mpost",
        bundle_description = "Verify MetaPost build artifacts",
        test_description = "Validate MetaPost diagram rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "svg",
        output_name = "app.svg",
        setup_description = "Verify MetaPost compiler (debug)",
        compile_description = "Render MetaPost sources to SVG via mpost",
        bundle_description = "Verify MetaPost debug artifacts",
        test_description = "Validate MetaPost rendering (verbose)",
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
