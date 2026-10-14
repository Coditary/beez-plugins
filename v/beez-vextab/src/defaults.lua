local M = {}

M.runnable = false

M.build_dir = "build/vextab"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.vextab_binary = "vextab-render"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[vextab-setup]"
M.log_prefix_compile = "[vextab-compile]"
M.log_prefix_bundle = "[vextab-bundle]"
M.log_prefix_test = "[vextab-test]"


M.common_inputs = {
    "**/*.vextab",
}

M.build_profiles = {
    code = {
        scope = "vextab",
        output_name = "app.svg",
        setup_description = "Verify VexTab guitar tab renderer",
        compile_description = "Render VexTab notation to SVG",
        bundle_description = "Verify VexTab build artifacts",
        test_description = "Validate VexTab notation sources",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.svg",
        setup_description = "Verify VexTab renderer (debug)",
        compile_description = "Render VexTab notation to SVG (debug)",
        bundle_description = "Verify VexTab debug artifacts",
        test_description = "Validate VexTab notation sources (verbose)",
        compile_args = "--verbose",
        test_args = "--verbose",
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
