local M = {}

M.runnable = false

M.build_dir = "build/cadquery"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.python_binary = "python3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[cadquery-setup]"
M.log_prefix_compile = "[cadquery-compile]"
M.log_prefix_bundle = "[cadquery-bundle]"
M.log_prefix_test = "[cadquery-test]"


M.common_inputs = {
    "**/cadquery/**/*.py",
    "**/*.py",
}

M.build_profiles = {
    code = {
        scope = "cadquery",
        output_format = "stl",
        output_name = "app.stl",
        setup_description = "Verify Python3 and CadQuery library",
        compile_description = "Run CadQuery Python scripts to export STL",
        bundle_description = "Verify CadQuery build artifacts",
        test_description = "Validate CadQuery model export",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_format = "obj",
        output_name = "app.obj",
        setup_description = "Verify Python3 and CadQuery (debug)",
        compile_description = "Run CadQuery Python scripts to export OBJ",
        bundle_description = "Verify CadQuery debug artifacts",
        test_description = "Validate CadQuery model export (verbose)",
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
