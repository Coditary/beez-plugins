local M = {}

M.runnable = false

M.build_dir = "build/implicitcad"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.extopenscad_binary = "extopenscad"
M.implicitcad_binary = "implicitcad"
M.runhaskell_binary = "runhaskell"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[implicitcad-setup]"
M.log_prefix_compile = "[implicitcad-compile]"
M.log_prefix_bundle = "[implicitcad-bundle]"
M.log_prefix_test = "[implicitcad-test]"


M.common_inputs = {
    "**/*.scad",
    "**/*.hs",
}

M.build_profiles = {
    code = {
        scope = "implicitcad",
        output_format = "stl",
        output_name = "app.stl",
        setup_description = "Verify ImplicitCAD extopenscad/implicitcad binary",
        compile_description = "Render ImplicitCAD sources to STL",
        bundle_description = "Verify ImplicitCAD build artifacts",
        test_description = "Validate ImplicitCAD model export",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "obj",
        output_name = "app.obj",
        setup_description = "Verify ImplicitCAD compiler (debug)",
        compile_description = "Render ImplicitCAD sources to OBJ",
        bundle_description = "Verify ImplicitCAD debug artifacts",
        test_description = "Validate ImplicitCAD model export (verbose)",
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
