local M = {}

M.runnable = false

M.build_dir = "build/revealjs"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.revealmd_binary = "reveal-md"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[revealjs-setup]"
M.log_prefix_compile = "[revealjs-compile]"
M.log_prefix_bundle = "[revealjs-bundle]"
M.log_prefix_test = "[revealjs-test]"


M.common_inputs = {
    "**/*.md",
}

M.build_profiles = {
    code = {
        scope = "revealjs",
        output_name = "index.html",
        setup_description = "Verify reveal-md slide compiler",
        compile_description = "Render reveal.js Markdown slides to static HTML",
        bundle_description = "Verify reveal.js build artifacts",
        test_description = "Validate reveal.js slide sources",
        compile_args = "--static",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "index.html",
        setup_description = "Verify reveal-md (debug)",
        compile_description = "Render reveal.js slides to static HTML (debug)",
        bundle_description = "Verify reveal.js debug artifacts",
        test_description = "Validate reveal.js slide sources (verbose)",
        compile_args = "--static --verbose",
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
