local M = {}

M.runnable = true

M.build_dir = "build/golo"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.golo_binary = "golo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[golo-setup]"
M.log_prefix_compile = "[golo-compile]"
M.log_prefix_bundle = "[golo-bundle]"
M.log_prefix_test = "[golo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.golo",
}

M.build_profiles = {
    code = {
        scope = "golo",
        output_name = "app",
        output_ext = "jar",
        setup_description = "Verify Golo JVM compiler and prepare build directory",
        compile_description = "Compile Golo sources to JVM jar with golo compile",
        bundle_description = "Verify Golo compile artifacts",
        test_description = "Run Golo modules with golo run",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "golo",
        output_name = "classes",
        output_ext = "",
        setup_description = "Verify Golo JVM compiler (debug)",
        compile_description = "Compile Golo sources to class directory (debug)",
        bundle_description = "Verify Golo debug compile artifacts",
        test_description = "Run Golo modules (verbose)",
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
