local M = {}

M.runnable = false

M.build_dir = "build/meson"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.meson_binary = "meson"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[meson-setup]"
M.log_prefix_compile = "[meson-compile]"
M.log_prefix_bundle = "[meson-bundle]"
M.log_prefix_test = "[meson-test]"


M.common_inputs = {
    "meson.build",
    "**/meson.build",
}

M.build_profiles = {
    code = {
        scope = "meson",
        output_name = "build.ok",
        setup_description = "Verify Meson CLI and configure build directory",
        compile_description = "Compile Meson project targets",
        bundle_description = "Verify Meson build artifacts",
        test_description = "Run Meson test suite",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        setup_description = "Verify Meson CLI and configure debug build",
        compile_description = "Compile Meson project with debug profile",
        bundle_description = "Verify Meson debug build artifacts",
        test_description = "Run Meson tests (verbose)",
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
