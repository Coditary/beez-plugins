local M = {}

M.runnable = false

M.build_dir = "build/openscad"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.openscad_binary = "openscad"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[openscad-setup]"
M.log_prefix_compile = "[openscad-compile]"
M.log_prefix_bundle = "[openscad-bundle]"
M.log_prefix_test = "[openscad-test]"


M.common_inputs = {
    "**/*.scad",
}

M.build_profiles = {
    code = {
        scope = "openscad",
        output_format = "stl",
        output_name = "app.stl",
        setup_description = "Verify OpenSCAD CAD compiler",
        compile_description = "Render OpenSCAD sources to STL via openscad",
        bundle_description = "Verify OpenSCAD build artifacts",
        test_description = "Validate OpenSCAD CAD model export",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "obj",
        output_name = "app.obj",
        setup_description = "Verify OpenSCAD compiler (debug)",
        compile_description = "Render OpenSCAD sources to OBJ via openscad",
        bundle_description = "Verify OpenSCAD debug artifacts",
        test_description = "Validate OpenSCAD model export (verbose)",
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
