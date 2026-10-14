local M = {}

M.runnable = false

M.build_dir = "build/twee"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.twee_binary = "twee"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[twee-setup]"
M.log_prefix_compile = "[twee-compile]"
M.log_prefix_bundle = "[twee-bundle]"
M.log_prefix_test = "[twee-test]"


M.common_inputs = {
    "**/*.twee",
    "**/*.tw",
}

M.build_profiles = {
    code = {
        scope = "twee",
        output_name = "app.html",
        setup_description = "Verify Twee/Twine compiler",
        compile_description = "Compile Twee/Twine sources to HTML",
        bundle_description = "Verify Twee build artifacts",
        test_description = "Validate Twee story compilation",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.html",
        setup_description = "Verify Twee/Twine compiler (debug)",
        compile_description = "Compile Twee/Twine sources to HTML (verbose)",
        bundle_description = "Verify Twee debug artifacts",
        test_description = "Validate Twee story compilation (verbose)",
        compile_args = "-v",
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
