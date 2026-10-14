local M = {}

M.runnable = false

M.build_dir = "build/mdbook"
M.bin_dir = M.build_dir .. "/html"
M.reports_dir = "report"

M.mdbook_binary = "mdbook"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mdbook-setup]"
M.log_prefix_compile = "[mdbook-compile]"
M.log_prefix_bundle = "[mdbook-bundle]"
M.log_prefix_test = "[mdbook-test]"


M.common_inputs = {
    "book.toml",
    "**/*.md",
}

M.build_profiles = {
    code = {
        scope = "mdbook",
        output_name = "index.html",
        setup_description = "Verify mdbook Rust documentation builder",
        compile_description = "Build mdbook web book from Markdown",
        bundle_description = "Verify mdbook HTML build artifacts",
        test_description = "Validate mdbook project with mdbook test",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "index.html",
        setup_description = "Verify mdbook Rust documentation builder (debug)",
        compile_description = "Build mdbook web book from Markdown (verbose)",
        bundle_description = "Verify mdbook debug build artifacts",
        test_description = "Validate mdbook project with mdbook test (verbose)",
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
