local M = {}

M.runnable = false

M.build_dir = "build/metafont"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mf_binary = "mf-nowin"
M.mf_fallback_binary = "mf"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[metafont-setup]"
M.log_prefix_compile = "[metafont-compile]"
M.log_prefix_bundle = "[metafont-bundle]"
M.log_prefix_test = "[metafont-test]"


M.common_inputs = {
    "**/*.mf",
    "**/*.fd",
}

M.build_profiles = {
    code = {
        scope = "metafont",
        mode = "localfont",
        output_name = "app.gf",
        setup_description = "Verify Metafont mf-nowin compiler",
        compile_description = "Compile Metafont sources to GF/PK fonts",
        bundle_description = "Verify Metafont build artifacts",
        test_description = "Validate Metafont font compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        mode = "proof",
        output_name = "app.gf",
        setup_description = "Verify Metafont mf-nowin compiler (debug)",
        compile_description = "Compile Metafont sources to GF/PK fonts (proof mode)",
        bundle_description = "Verify Metafont debug artifacts",
        test_description = "Validate Metafont font compilation (verbose)",
        test_args = "-recorder",
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
