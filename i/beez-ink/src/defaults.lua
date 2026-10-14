local M = {}

M.runnable = false

M.build_dir = "build/ink"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.inklecate_binary = "inklecate"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ink-setup]"
M.log_prefix_compile = "[ink-compile]"
M.log_prefix_bundle = "[ink-bundle]"
M.log_prefix_test = "[ink-test]"


M.common_inputs = {
    "**/*.ink",
}

M.build_profiles = {
    code = {
        scope = "ink",
        output_name = "story.json",
        setup_description = "Verify Inkle inklecate compiler",
        compile_description = "Compile Ink narrative sources to JSON story",
        bundle_description = "Verify Ink build artifacts",
        test_description = "Validate Ink story compilation",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "story.json",
        setup_description = "Verify Inkle inklecate compiler (debug)",
        compile_description = "Compile Ink narrative sources to JSON story (verbose)",
        bundle_description = "Verify Ink debug artifacts",
        test_description = "Validate Ink story compilation (verbose)",
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
