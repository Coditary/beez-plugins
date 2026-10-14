local M = {}

M.runnable = false

M.build_dir = "build/dhall"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.dhall_binary = "dhall"
M.dhall_to_json = "dhall-to-json"
M.dhall_to_yaml = "dhall-to-yaml"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dhall-setup]"
M.log_prefix_compile = "[dhall-compile]"
M.log_prefix_bundle = "[dhall-bundle]"
M.log_prefix_test = "[dhall-test]"


M.common_inputs = {
    "**/*.dhall",
}

M.build_profiles = {
    code = {
        scope = "dhall",
        output_name = "config.json",
        output_format = "json",
        setup_description = "Verify Dhall CLI and resolve imports",
        compile_description = "Evaluate Dhall expressions to JSON/YAML",
        bundle_description = "Verify Dhall export artifacts",
        test_description = "Validate Dhall expression syntax and formatting",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "config.yaml",
        output_format = "yaml",
        setup_description = "Verify Dhall CLI (debug)",
        compile_description = "Evaluate Dhall expressions to YAML (debug)",
        bundle_description = "Verify Dhall debug export artifacts",
        test_description = "Validate Dhall expressions (verbose)",
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
