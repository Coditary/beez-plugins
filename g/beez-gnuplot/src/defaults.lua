local M = {}

M.runnable = false

M.build_dir = "build/gnuplot"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.gnuplot_binary = "gnuplot"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gnuplot-setup]"
M.log_prefix_compile = "[gnuplot-compile]"
M.log_prefix_bundle = "[gnuplot-bundle]"
M.log_prefix_test = "[gnuplot-test]"


M.common_inputs = {
    "**/*.gp",
    "**/*.gnuplot",
}

M.build_profiles = {
    code = {
        scope = "gnuplot",
        terminal = "png",
        output_name = "app.png",
        setup_description = "Verify gnuplot plotting engine",
        compile_description = "Render gnuplot scripts to PNG",
        bundle_description = "Verify gnuplot build artifacts",
        test_description = "Validate gnuplot script rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        terminal = "svg",
        output_name = "app.svg",
        setup_description = "Verify gnuplot engine (debug)",
        compile_description = "Render gnuplot scripts to SVG",
        bundle_description = "Verify gnuplot debug artifacts",
        test_description = "Validate gnuplot rendering (verbose)",
        test_args = "",
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
