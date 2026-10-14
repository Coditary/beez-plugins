local M = {}

M.runnable = false

M.build_dir = "build/graphviz"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.dot_binary = "dot"
M.neato_binary = "neato"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[graphviz-setup]"
M.log_prefix_compile = "[graphviz-compile]"
M.log_prefix_bundle = "[graphviz-bundle]"
M.log_prefix_test = "[graphviz-test]"


M.common_inputs = {
    "**/*.dot",
    "**/*.gv",
}

M.build_profiles = {
    code = {
        scope = "graphviz",
        layout_engine = "dot",
        output_format = "png",
        output_name = "app.png",
        setup_description = "Verify Graphviz dot layout engine",
        compile_description = "Render DOT/GV graphs to PNG via dot",
        bundle_description = "Verify Graphviz build artifacts",
        test_description = "Validate DOT/GV graph rendering",
        test_args = "",
    },

    debug = {
        scope = "debug",
        layout_engine = "neato",
        output_format = "svg",
        output_name = "app.svg",
        setup_description = "Verify Graphviz neato layout engine",
        compile_description = "Render DOT/GV graphs to SVG via neato",
        bundle_description = "Verify Graphviz debug artifacts",
        test_description = "Validate DOT/GV graph rendering (verbose)",
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
