local M = {}

M.runnable = false

M.build_dir = "build/yuck"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.eww_binary = "eww"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[yuck-setup]"
M.log_prefix_compile = "[yuck-compile]"
M.log_prefix_bundle = "[yuck-bundle]"
M.log_prefix_test = "[yuck-test]"


M.common_inputs = {
    "eww.yuck",
    "**/*.yuck",
    "eww.scss",
    "eww.css",
}

M.build_profiles = {
    code = {
        scope = "yuck",
        output_name = "validate.ok",
        setup_description = "Verify Eww CLI and widget dependencies",
        compile_description = "Validate and load Eww Yuck widget configuration",
        bundle_description = "Verify Eww Yuck configuration artifacts",
        test_description = "Validate Yuck widget syntax and formatting",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "validate.ok",
        setup_description = "Verify Eww CLI (debug)",
        compile_description = "Validate Eww Yuck configuration with debug output",
        bundle_description = "Verify Eww debug configuration artifacts",
        test_description = "Validate Yuck widgets (verbose)",
        test_args = "--debug",
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
