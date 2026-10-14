local M = {}

M.runnable = false

M.build_dir = "build/sphinx-doc"
M.bin_dir = M.build_dir .. "/html"
M.reports_dir = "report"

M.sphinx_build_binary = "sphinx-build"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sphinx-doc-setup]"
M.log_prefix_compile = "[sphinx-doc-compile]"
M.log_prefix_bundle = "[sphinx-doc-bundle]"
M.log_prefix_test = "[sphinx-doc-test]"


M.common_inputs = {
    "conf.py",
    "**/*.rst",
}

M.build_profiles = {
    code = {
        scope = "sphinx-doc",
        builder = "html",
        output_name = "index.html",
        setup_description = "Verify Sphinx documentation builder",
        compile_description = "Build Sphinx HTML documentation from reST",
        bundle_description = "Verify Sphinx HTML build artifacts",
        test_description = "Run Sphinx linkcheck validation",
        test_builder = "linkcheck",
    },

    debug = {
        scope = "debug",
        builder = "html",
        output_name = "index.html",
        setup_description = "Verify Sphinx documentation builder (debug)",
        compile_description = "Build Sphinx HTML documentation (verbose)",
        bundle_description = "Verify Sphinx debug build artifacts",
        test_description = "Run Sphinx linkcheck validation (verbose)",
        test_builder = "linkcheck",
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
