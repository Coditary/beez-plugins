local M = {}

M.runnable = true

M.build_dir = "build/janet"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.janet_binary = "janet"
M.jpm_binary = "jpm"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[janet-setup]"
M.log_prefix_compile = "[janet-compile]"
M.log_prefix_bundle = "[janet-bundle]"
M.log_prefix_test = "[janet-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "project.janet",
    "**/project.janet",
    "**/*.janet",
}

M.build_profiles = {
    code = {
        scope = "janet",
        output_name = "app",
        setup_description = "Install Janet dependencies with jpm deps",
        compile_description = "Static compile Janet to native executable (jpm build/quickbin)",
        bundle_description = "Verify Janet static build artifacts",
        test_description = "Run Janet tests with jpm test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Install Janet dependencies with jpm deps (debug)",
        compile_description = "Static compile Janet to native executable (debug)",
        bundle_description = "Verify Janet debug static build artifacts",
        test_description = "Run Janet tests with jpm test (verbose)",
        test_args = "--verbose",
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
