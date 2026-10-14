local M = {}

M.runnable = false

M.build_dir = "build/qiskit"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.python_binary = "python3"
M.pip_binary = "pip3"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[qiskit-setup]"
M.log_prefix_compile = "[qiskit-compile]"
M.log_prefix_bundle = "[qiskit-bundle]"
M.log_prefix_test = "[qiskit-test]"


M.common_inputs = {
    "**/*.qasm",
    "requirements.txt",
    "**/requirements.txt",
}

M.build_profiles = {
    code = {
        scope = "qiskit",
        output_name = "app",
        setup_description = "Install Qiskit dependencies from requirements.txt",
        compile_description = "Transpile OpenQASM via Qiskit",
        bundle_description = "Verify Qiskit transpile artifacts",
        test_description = "Run Qiskit tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Install Qiskit dependencies (debug)",
        compile_description = "Transpile OpenQASM via Qiskit (debug)",
        bundle_description = "Verify Qiskit debug artifacts",
        test_description = "Run Qiskit tests (verbose)",
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
