local M = {}

M.runnable = true

M.build_dir = "build/vala"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.valac_binary = "valac"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[vala-setup]"
M.log_prefix_compile = "[vala-compile]"
M.log_prefix_bundle = "[vala-bundle]"
M.log_prefix_test = "[vala-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "meson.build",
    "**/meson.build",
    "**/*.vala",
}

M.compile_exclude = [[/(\.git|build|_build)/]]

M.build_profiles = {
    code = {
        scope = "vala",
        output_name = "app",
        setup_description = "Verify valac and configure meson build",
        compile_description = "Compile Vala sources with valac or meson compile",
        bundle_description = "Verify Vala compile stamp",
        test_description = "Run Vala/meson tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "vala",
        output_name = "app",
        setup_description = "Verify valac and configure meson build (debug)",
        compile_description = "Compile Vala sources (debug)",
        bundle_description = "Verify Vala debug compile stamp",
        test_description = "Run Vala/meson tests (verbose)",
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
