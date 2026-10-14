local M = {}

M.runnable = false

M.build_dir = "build/neatroff"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.neatroff_binary = "neatroff"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[neatroff-setup]"
M.log_prefix_compile = "[neatroff-compile]"
M.log_prefix_bundle = "[neatroff-bundle]"
M.log_prefix_test = "[neatroff-test]"


M.common_inputs = {
    "**/*.nr",
    "**/*.roff",
    "**/*.ms",
}

M.build_profiles = {
    code = {
        scope = "neatroff",
        output_name = "app.ps",
        setup_description = "Verify Neatroff troff successor compiler",
        compile_description = "Compile Neatroff document to PostScript",
        bundle_description = "Verify Neatroff build artifacts",
        test_description = "Validate Neatroff document sources",
        compile_args = "-Tps",
        test_args = "--version",
    },

    debug = {
        scope = "debug",
        output_name = "app.ps",
        setup_description = "Verify Neatroff compiler (debug)",
        compile_description = "Compile Neatroff document to PostScript (debug)",
        bundle_description = "Verify Neatroff debug artifacts",
        test_description = "Validate Neatroff document sources (verbose)",
        compile_args = "-Tps -a",
        test_args = "--version",
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
