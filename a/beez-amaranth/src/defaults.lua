local M = {}

M.runnable = true

M.build_dir = "build/amaranth"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.python_binary = "python3"
M.pip_binary = "pip3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[amaranth-setup]"
M.log_prefix_compile = "[amaranth-compile]"
M.log_prefix_bundle = "[amaranth-bundle]"
M.log_prefix_test = "[amaranth-test]"


M.common_inputs = {
    "**/*.py",
    "requirements.txt",
    "pyproject.toml",
}

M.build_profiles = {
    code = {
        scope = "amaranth",
        output_name = "elaborate.ok",
        rtl_output = "top.v",
        setup_description = "Install Amaranth HDL Python dependencies",
        compile_description = "Elaborate Amaranth Python HDL sources to RTL",
        bundle_description = "Verify Amaranth RTL elaboration artifacts",
        test_description = "Validate Amaranth HDL Python sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "elaborate.ok",
        rtl_output = "top-debug.v",
        setup_description = "Install Amaranth dependencies (debug)",
        compile_description = "Elaborate Amaranth HDL with verbose output (debug)",
        bundle_description = "Verify Amaranth debug RTL artifacts",
        test_description = "Validate Amaranth HDL sources (verbose)",
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
