local M = {}

M.runnable = false

M.build_dir = "build/drools"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.drools_binary = "drools"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[drools-setup]"
M.log_prefix_compile = "[drools-compile]"
M.log_prefix_bundle = "[drools-bundle]"
M.log_prefix_test = "[drools-test]"


M.common_inputs = {
    "**/*.drl",
    "**/*.dsl",
}

M.build_profiles = {
    code = {
        scope = "drools",
        output_name = "rules.jar",
        setup_description = "Verify Drools rule compiler binary",
        compile_description = "Compile Drools rules and DSL to KJAR",
        bundle_description = "Verify Drools build artifacts",
        test_description = "Validate Drools rule compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "rules-debug.jar",
        setup_description = "Verify Drools rule compiler binary (debug)",
        compile_description = "Compile Drools rules and DSL to KJAR (verbose)",
        bundle_description = "Verify Drools debug artifacts",
        test_description = "Validate Drools rule compilation (verbose)",
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
