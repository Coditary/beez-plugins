local M = {}

M.runnable = false

M.build_dir = "build/structurizr"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.structurizr_binary = "structurizr-cli"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[structurizr-setup]"
M.log_prefix_compile = "[structurizr-compile]"
M.log_prefix_bundle = "[structurizr-bundle]"
M.log_prefix_test = "[structurizr-test]"


M.common_inputs = {
    "workspace.dsl",
    "**/*.dsl",
}

M.build_profiles = {
    code = {
        scope = "structurizr",
        export_format = "plantuml",
        output_name = "export.ok",
        setup_description = "Verify Structurizr CLI and workspace DSL",
        compile_description = "Export Structurizr C4 workspace diagrams",
        bundle_description = "Verify Structurizr export artifacts",
        test_description = "Validate Structurizr workspace DSL",
        test_args = "",
    },

    debug = {
        scope = "debug",
        export_format = "mermaid",
        output_name = "export.ok",
        setup_description = "Verify Structurizr CLI (debug)",
        compile_description = "Export Structurizr workspace to Mermaid (debug)",
        bundle_description = "Verify Structurizr debug export artifacts",
        test_description = "Validate Structurizr workspace DSL (verbose)",
        test_args = "-verbose",
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
