local M = {}

M.runnable = false

M.build_dir = "build/remarkjs"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.remark_binary = "remark"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[remarkjs-setup]"
M.log_prefix_compile = "[remarkjs-compile]"
M.log_prefix_bundle = "[remarkjs-bundle]"
M.log_prefix_test = "[remarkjs-test]"


M.common_inputs = {
    "**/*.md",
}

M.build_profiles = {
    code = {
        scope = "remarkjs",
        output_name = "app.html",
        setup_description = "Verify remark.js slide compiler",
        compile_description = "Render remark.js Markdown slides to HTML",
        bundle_description = "Verify remark.js build artifacts",
        test_description = "Validate remark.js slide sources",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.html",
        setup_description = "Verify remark.js compiler (debug)",
        compile_description = "Render remark.js slides to HTML (debug)",
        bundle_description = "Verify remark.js debug artifacts",
        test_description = "Validate remark.js slide sources (verbose)",
        compile_args = "--verbose",
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
