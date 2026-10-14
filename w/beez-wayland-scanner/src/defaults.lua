local M = {}

M.runnable = false

M.build_dir = "build/wayland-scanner"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.wayland_scanner_binary = "wayland-scanner"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[wayland-scanner-setup]"
M.log_prefix_compile = "[wayland-scanner-compile]"
M.log_prefix_bundle = "[wayland-scanner-bundle]"
M.log_prefix_test = "[wayland-scanner-test]"


M.common_inputs = {
    "**/*.xml",
}

M.build_profiles = {
    code = {
        scope = "wayland-scanner",
        output_name = "protocol-code.c",
        header_name = "protocol-client.h",
        scanner_mode = "public-code",
        header_mode = "client-header",
        setup_description = "Verify Wayland protocol scanner",
        compile_description = "Generate C headers and code from Wayland protocol XML",
        bundle_description = "Verify Wayland scanner-generated artifacts",
        test_description = "Validate Wayland protocol XML generation",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "protocol-code.c",
        header_name = "protocol-client.h",
        scanner_mode = "private-code",
        header_mode = "server-header",
        setup_description = "Verify Wayland protocol scanner (debug)",
        compile_description = "Generate private/server Wayland protocol code",
        bundle_description = "Verify Wayland scanner debug artifacts",
        test_description = "Validate Wayland protocol XML generation (verbose)",
        compile_args = "",
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
