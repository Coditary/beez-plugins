local M = {}

M.runnable = false

M.build_dir = "build/skidl"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.python_binary = "python3"
M.pip_binary = "pip3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[skidl-setup]"
M.log_prefix_compile = "[skidl-compile]"
M.log_prefix_bundle = "[skidl-bundle]"
M.log_prefix_test = "[skidl-test]"


M.common_inputs = {
    "**/*_skidl.py",
    "**/*.py",
    "requirements.txt",
    "**/requirements.txt",
}

M.build_profiles = {
    code = {
        scope = "skidl",
        output_name = "netlist.net",
        backend = "kicad",
        setup_description = "Install SKiDL Python PCB netlist dependencies",
        compile_description = "Generate KiCad netlist from SKiDL Python sources",
        bundle_description = "Verify SKiDL KiCad netlist artifacts",
        test_description = "Validate SKiDL netlist generation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "netlist.net",
        backend = "kicad",
        setup_description = "Install SKiDL dependencies (debug)",
        compile_description = "Generate KiCad netlist from SKiDL (verbose)",
        bundle_description = "Verify SKiDL debug netlist artifacts",
        test_description = "Validate SKiDL netlist generation (verbose)",
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
