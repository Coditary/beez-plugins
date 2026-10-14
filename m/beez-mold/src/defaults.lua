local M = {}

M.runnable = false

M.build_dir = "build/mold"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.mold_binary = "mold"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[mold-setup]"
M.log_prefix_compile = "[mold-compile]"
M.log_prefix_bundle = "[mold-bundle]"
M.log_prefix_test = "[mold-test]"


M.common_inputs = {
    "compile_commands.json",
    "**/compile_commands.json",
    "**/*.o",
}

M.build_profiles = {
    code = {
        scope = "mold",
        output_name = "app",
        setup_description = "Verify Mold fast linker",
        compile_description = "Link object files with Mold via compile_commands.json",
        bundle_description = "Verify Mold-linked binary artifacts",
        test_description = "Validate Mold link output",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify Mold fast linker (debug)",
        compile_description = "Link object files with Mold (debug symbols)",
        bundle_description = "Verify Mold debug binary artifacts",
        test_description = "Validate Mold link output (verbose)",
        compile_args = "--print-map",
        test_args = "--version",
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
