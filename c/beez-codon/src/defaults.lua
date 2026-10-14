local M = {}

M.runnable = true

M.build_dir = "build/codon"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.codon_binary = "codon"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[codon-setup]"
M.log_prefix_compile = "[codon-compile]"
M.log_prefix_bundle = "[codon-bundle]"
M.log_prefix_test = "[codon-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "codon.yml",
    "**/codon.yml",
    "**/*.py",
}

M.build_profiles = {
    code = {
        scope = "codon",
        output_name = "app",
        release_flag = "-release",
        setup_description = "Verify Codon compiler (Python to LLVM native)",
        compile_description = "Compile Python to native executable with Codon",
        bundle_description = "Verify Codon native build artifacts",
        test_description = "Run Python tests (pytest)",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        release_flag = "-debug",
        setup_description = "Verify Codon compiler (debug)",
        compile_description = "Compile Python to native executable (debug)",
        bundle_description = "Verify Codon debug build artifacts",
        test_description = "Run Python tests (pytest, verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
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

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
