local M = {}

M.runnable = false

M.build_dir = "build/lld"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.lld_binary = "ld.lld"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[lld-setup]"
M.log_prefix_compile = "[lld-compile]"
M.log_prefix_bundle = "[lld-bundle]"
M.log_prefix_test = "[lld-test]"


M.common_inputs = {
    "compile_commands.json",
    "**/compile_commands.json",
    "**/*.o",
}

M.build_profiles = {
    code = {
        scope = "lld",
        output_name = "app",
        setup_description = "Verify LLVM LLD linker",
        compile_description = "Link object files with LLD via compile_commands.json",
        bundle_description = "Verify LLD-linked binary artifacts",
        test_description = "Validate LLD link output",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify LLVM LLD linker (debug)",
        compile_description = "Link object files with LLD (debug symbols)",
        bundle_description = "Verify LLD debug binary artifacts",
        test_description = "Validate LLD link output (verbose)",
        compile_args = "--verbose",
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
