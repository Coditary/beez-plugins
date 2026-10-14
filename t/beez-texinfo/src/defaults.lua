local M = {}

M.runnable = false

M.build_dir = "build/texinfo"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.makeinfo_binary = "makeinfo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[texinfo-setup]"
M.log_prefix_compile = "[texinfo-compile]"
M.log_prefix_bundle = "[texinfo-bundle]"
M.log_prefix_test = "[texinfo-test]"


M.common_inputs = {
    "**/*.texi",
    "**/*.texinfo",
}

M.build_profiles = {
    code = {
        scope = "texinfo",
        output_name = "index.html",
        setup_description = "Verify GNU makeinfo for Texinfo",
        compile_description = "Build Texinfo documentation to HTML",
        bundle_description = "Verify Texinfo HTML build artifacts",
        test_description = "Validate Texinfo source with makeinfo --check",
        compile_args = "--html",
    },

    debug = {
        scope = "debug",
        output_name = "index.html",
        setup_description = "Verify GNU makeinfo for Texinfo (debug)",
        compile_description = "Build Texinfo documentation to HTML (verbose)",
        bundle_description = "Verify Texinfo debug build artifacts",
        test_description = "Validate Texinfo source with makeinfo --check (verbose)",
        compile_args = "--html --verbose",
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
