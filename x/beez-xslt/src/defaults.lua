local M = {}

M.runnable = false

M.build_dir = "build/xslt"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.xsltproc_binary = "xsltproc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[xslt-setup]"
M.log_prefix_compile = "[xslt-compile]"
M.log_prefix_bundle = "[xslt-bundle]"
M.log_prefix_test = "[xslt-test]"


M.common_inputs = {
    "**/*.xsl",
    "**/*.xslt",
    "**/*.xq",
    "**/*.xquery",
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "xslt",
        output_name = "app",
        setup_description = "Verify XSLT and prepare build directory",
        compile_description = "Compile/validate XSLT targets",
        bundle_description = "Verify xslt compile stamp",
        test_description = "Run primary XSLT target",
        test_args = "",
    },

    debug = {
        scope = "xslt",
        output_name = "app",
        setup_description = "Verify XSLT and prepare build directory (debug)",
        compile_description = "Compile/validate XSLT targets (debug)",
        bundle_description = "Verify xslt debug compile stamp",
        test_description = "Run primary XSLT target (debug)",
        test_args = "",
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
