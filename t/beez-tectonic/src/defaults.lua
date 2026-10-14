local M = {}

M.runnable = false

M.build_dir = "build/tectonic"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.tectonic_binary = "tectonic"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tectonic-setup]"
M.log_prefix_compile = "[tectonic-compile]"
M.log_prefix_bundle = "[tectonic-bundle]"
M.log_prefix_test = "[tectonic-test]"


M.common_inputs = {
    "Tectonic.toml",
    "**/*.tex",
    "main.tex",
}

M.build_profiles = {
    code = {
        scope = "tectonic",
        output_name = "main",
        setup_description = "Verify Tectonic Rust LaTeX engine",
        compile_description = "Compile LaTeX document to PDF via Tectonic",
        bundle_description = "Verify Tectonic PDF output",
        test_description = "Compile LaTeX test documents",
        compile_args = "",
        compile_passes = 1,
    },

    debug = {
        scope = "debug",
        output_name = "main",
        setup_description = "Verify Tectonic compiler (debug)",
        compile_description = "Compile LaTeX document to PDF via Tectonic (debug)",
        bundle_description = "Verify Tectonic debug PDF output",
        test_description = "Compile LaTeX test documents (verbose)",
        compile_args = "--keep-logs",
        compile_passes = 1,
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
