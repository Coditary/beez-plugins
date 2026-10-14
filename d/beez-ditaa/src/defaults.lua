local M = {}

M.runnable = false

M.build_dir = "build/ditaa"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ditaa_binary = "ditaa"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ditaa-setup]"
M.log_prefix_compile = "[ditaa-compile]"
M.log_prefix_bundle = "[ditaa-bundle]"
M.log_prefix_test = "[ditaa-test]"


M.common_inputs = {
    "**/*.ditaa",
    "**/*.md",
}

M.build_profiles = {
    code = {
        scope = "ditaa",
        output_format = "png",
        output_name = "app.png",
        setup_description = "Verify ditaa ASCII art to PNG converter",
        compile_description = "Render ditaa ASCII art to PNG",
        bundle_description = "Verify ditaa build artifacts",
        test_description = "Validate ditaa ASCII art rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "png",
        output_name = "app.png",
        setup_description = "Verify ditaa converter (debug)",
        compile_description = "Render ditaa ASCII art to PNG (debug)",
        bundle_description = "Verify ditaa debug artifacts",
        test_description = "Validate ditaa rendering (verbose)",
        test_args = "-E",
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
