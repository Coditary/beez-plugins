local M = {}

M.runnable = false

M.build_dir = "build/pikchr"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.pikchr_binary = "pikchr"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[pikchr-setup]"
M.log_prefix_compile = "[pikchr-compile]"
M.log_prefix_bundle = "[pikchr-bundle]"
M.log_prefix_test = "[pikchr-test]"


M.common_inputs = {
    "**/*.pikchr",
    "**/*.pik",
}

M.build_profiles = {
    code = {
        scope = "pikchr",
        output_name = "app.svg",
        setup_description = "Verify Pikchr diagram renderer",
        compile_description = "Render Pikchr sources to inline SVG",
        bundle_description = "Verify Pikchr build artifacts",
        test_description = "Validate Pikchr diagram sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.svg",
        setup_description = "Verify Pikchr renderer (debug)",
        compile_description = "Render Pikchr sources to SVG (debug)",
        bundle_description = "Verify Pikchr debug artifacts",
        test_description = "Validate Pikchr sources (verbose)",
        test_args = "-v",
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
