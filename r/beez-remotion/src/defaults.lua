local M = {}

M.runnable = false

M.build_dir = "build/remotion"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.remotion_binary = "npx"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[remotion-setup]"
M.log_prefix_compile = "[remotion-compile]"
M.log_prefix_bundle = "[remotion-bundle]"
M.log_prefix_test = "[remotion-test]"


M.common_inputs = {
    "package.json",
    "**/package.json",
    "**/*.ts",
    "**/*.tsx",
}

M.build_profiles = {
    code = {
        scope = "remotion",
        output_name = "app.mp4",
        setup_description = "Verify Remotion CLI (npx remotion)",
        compile_description = "Render Remotion composition to MP4",
        bundle_description = "Verify Remotion build artifacts",
        test_description = "Validate Remotion project sources",
        compile_args = "",
        test_args = "versions",
    },

    debug = {
        scope = "debug",
        output_name = "app.mp4",
        setup_description = "Verify Remotion CLI (debug)",
        compile_description = "Render Remotion composition to MP4 (debug)",
        bundle_description = "Verify Remotion debug artifacts",
        test_description = "Validate Remotion project sources (verbose)",
        compile_args = "--log=verbose",
        test_args = "versions",
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
