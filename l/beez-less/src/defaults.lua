local M = {}

M.runnable = false

M.build_dir = "build/less"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.lessc_binary = "lessc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[less-setup]"
M.log_prefix_compile = "[less-compile]"
M.log_prefix_bundle = "[less-bundle]"
M.log_prefix_test = "[less-test]"


M.common_inputs = {
    "**/*.less",
}

M.build_profiles = {
    code = {
        scope = "less",
        compress = true,
        output_name = "app.css",
        setup_description = "Verify LESS compiler",
        compile_description = "Compile LESS to compressed CSS",
        bundle_description = "Verify LESS build artifacts",
        test_description = "Validate LESS compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        compress = false,
        output_name = "app.css",
        setup_description = "Verify LESS compiler (debug)",
        compile_description = "Compile LESS to expanded CSS",
        bundle_description = "Verify LESS debug artifacts",
        test_description = "Validate LESS compilation (verbose)",
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
