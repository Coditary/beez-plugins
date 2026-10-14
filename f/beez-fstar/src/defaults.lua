local M = {}

M.runnable = false

M.build_dir = "build/fstar"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.fstar_binary = "fstar"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fstar-setup]"
M.log_prefix_compile = "[fstar-compile]"
M.log_prefix_bundle = "[fstar-bundle]"
M.log_prefix_test = "[fstar-test]"


M.common_inputs = {
    "**/*.fst",
}

M.build_profiles = {
    code = {
        scope = "fstar",
        output_name = "app",
        setup_description = "Verify fstar binary and prepare build directory",
        compile_description = "Verify F* .fst modules with fstar --cache_checked_modules",
        bundle_description = "Verify F* checked module artifacts",
        test_description = "Run F* tests in t/ with prove",
        test_args = "",
    },

    debug = {
        scope = "fstar",
        output_name = "app",
        setup_description = "Verify fstar binary and prepare build directory (debug)",
        compile_description = "Verify F* .fst modules with fstar --cache_checked_modules (debug)",
        bundle_description = "Verify F* checked module artifacts (debug)",
        test_description = "Run F* tests in t/ with prove (verbose)",
        test_args = "-v",
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
