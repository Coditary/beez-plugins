local M = {}

M.runnable = false

M.build_dir = "build/mermaid"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mmdc_binary = "mmdc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mermaid-setup]"
M.log_prefix_compile = "[mermaid-compile]"
M.log_prefix_bundle = "[mermaid-bundle]"
M.log_prefix_test = "[mermaid-test]"


M.common_inputs = {
    "**/*.mmd",
    "**/*.mermaid",
}

M.build_profiles = {
    code = {
        scope = "mermaid",
        output_name = "app.png",
        setup_description = "Verify Mermaid CLI (mmdc) diagram compiler",
        compile_description = "Render Mermaid diagram to PNG",
        bundle_description = "Verify Mermaid build artifacts",
        test_description = "Validate Mermaid sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.png",
        setup_description = "Verify Mermaid CLI (debug)",
        compile_description = "Render Mermaid diagram to PNG (debug)",
        bundle_description = "Verify Mermaid debug artifacts",
        test_description = "Validate Mermaid sources (verbose)",
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
