local M = {}

M.runnable = false

M.build_dir = "build/marp"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.marp_binary = "marp"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[marp-setup]"
M.log_prefix_compile = "[marp-compile]"
M.log_prefix_bundle = "[marp-bundle]"
M.log_prefix_test = "[marp-test]"


M.common_inputs = {
    "**/*.md",
}

M.build_profiles = {
    code = {
        scope = "marp",
        output_name = "app.pdf",
        setup_description = "Verify Marp CLI slide compiler",
        compile_description = "Render Marp Markdown slides to PDF",
        bundle_description = "Verify Marp build artifacts",
        test_description = "Validate Marp slide sources",
        compile_args = "--pdf",
        test_args = "--no-stdout",
    },

    debug = {
        scope = "debug",
        output_name = "app.html",
        setup_description = "Verify Marp CLI (debug)",
        compile_description = "Render Marp slides to HTML (debug)",
        bundle_description = "Verify Marp debug artifacts",
        test_description = "Validate Marp slide sources (verbose)",
        compile_args = "",
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
